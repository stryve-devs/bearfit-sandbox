import { Request, Response, NextFunction } from "express";
import {
  registerUser,
  loginUser,
  refreshAccessToken,
} from "../services/authService";
import { googleSignIn } from "../services/authService";
import otpService from '../services/otpService';

/* =======================
   REGISTER
======================= */
export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { name, email, password, username } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        message: "name, email, and password are required",
      });
    }

    const user = await registerUser({
      name,
      email,
      password,
      username,
    });

    return res.status(201).json({
      message: "User registered successfully",
      user,
    });
  } catch (error: any) {
    return res.status(400).json({
      message: error.message || "Registration failed",
    });
  }
};

/* =======================
   LOGIN
======================= */
export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        message: "email and password are required",
      });
    }

    const result = await loginUser({ email, password });

    return res.status(200).json({
      message: "Login successful",
      ...result,
    });
  } catch (error: any) {
    return res.status(401).json({
      message: error.message || "Login failed",
    });
  }
};

/* =======================
   REFRESH TOKEN (STEP 3.7)
======================= */
export const refresh = async (req: Request, res: Response) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({
        message: "refreshToken is required",
      });
    }

    const tokens = await refreshAccessToken(refreshToken);

    return res.status(200).json({
      message: "Token refreshed successfully",
      ...tokens,
    });
  } catch (error: any) {
    return res.status(401).json({
      message: error.message || "Invalid refresh token",
    });
  }
};

/* =======================
   GOOGLE AUTH
======================= */
export const googleAuth = async (req: Request, res: Response) => {
  try {
    const { idToken } = req.body;
    if (!idToken) {
      return res.status(400).json({ message: "idToken is required" });
    }

    const result = await googleSignIn(idToken);

    return res.status(200).json({ message: "Google sign-in successful", ...result });
  } catch (error: any) {
    return res.status(400).json({ message: error.message || "Google auth failed" });
  }
};

/* =======================
   CHECK EMAIL EXISTS
   GET /auth/exists?email=...
======================= */
export const checkEmailExists = async (req: Request, res: Response) => {
  try {
    const email = String(req.query.email || '').trim();
    if (!email) {
      return res.status(400).json({ message: 'email query parameter is required' });
    }

    const prisma = (await import('../config/prismaClient')).default;
    // Only select a minimal field to avoid deserializing problematic fields
    // (e.g. mismatched enums). We only need to know whether a record exists.
    const user = await prisma.users.findUnique({ where: { email }, select: { user_id: true } });

    return res.status(200).json({ exists: !!user });
  } catch (error: any) {
    console.error('checkEmailExists error', error);
    return res.status(500).json({ message: 'Failed to check email' });
  }
};

/* =======================
   SEND OTP
   POST /auth/send-otp { email }
======================= */
export const sendOtp = async (req: Request, res: Response) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: 'email is required' });

    await otpService.sendOtpToEmail(String(email).trim());
    return res.status(200).json({ message: 'OTP sent' });
  } catch (error: any) {
    if (error.message === 'email_not_configured') {
      return res.status(500).json({ message: 'Email service not configured on server' });
    }
    if (error.message === 'email_auth_error') {
      return res.status(500).json({ message: 'Email SMTP authentication failed (check EMAIL_USER/EMAIL_PASS).' });
    }
    if (error.message === 'email_send_failed') {
      return res.status(500).json({ message: 'Failed to send OTP email' });
    }
    console.error('sendOtp error', error);
    return res.status(500).json({ message: 'Failed to send OTP' });
  }
};

/* =======================
   VERIFY OTP
   POST /auth/verify-otp { email, code }
======================= */
export const verifyOtp = async (req: Request, res: Response) => {
  try {
    const { email, code } = req.body;
    if (!email || !code) return res.status(400).json({ message: 'email and code are required' });

    const ok = await otpService.verifyOtpForEmail(String(email).trim(), String(code).trim());
    if (!ok) return res.status(400).json({ message: 'Invalid or expired code' });
    return res.status(200).json({ message: 'OTP verified' });
  } catch (error: any) {
    console.error('verifyOtp error', error);
    return res.status(500).json({ message: 'Failed to verify OTP' });
  }
};
