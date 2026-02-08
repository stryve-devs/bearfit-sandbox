import { Request, Response, NextFunction } from "express";
import {
  registerUser,
  loginUser,
  refreshAccessToken,
} from "../services/authService";
import { googleSignIn } from "../services/authService";
import prisma from '../config/prismaClient';
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
    const { idToken, username, name, email } = req.body as { idToken?: string; username?: string; name?: string; email?: string };

    // If we have an ID token, pass to googleSignIn which decodes/verifies and creates user if needed.
    if (idToken) {
      const result = await googleSignIn(idToken, { username, name });
      return res.status(200).json({ message: 'Google sign-in successful', ...result });
    }

    // Fallback: client provided an email (e.g., Google sign-in on some platforms didn't return idToken).
    if (email) {
      // If user already exists, treat as sign-in.
      const existing = await prisma.users.findUnique({ where: { email }, select: { user_id: true, name: true, email: true, username: true } });
      if (existing) {
        // Use loginUser path by creating a temporary password? Instead, return the existing user info without tokens.
        // For convenience we'll return a 200 with user (caller can choose next step). But better to return error so client can start sign-in.
        return res.status(200).json({ message: 'User already exists', user: existing });
      }

      // Create user server-side using a generated password (password is not used for Google users).
      const randomPassword = Math.random().toString(36) + Date.now().toString(36);
      const created = await registerUser({ name: name || email.split('@')[0], email, password: randomPassword, username });

      // Immediately log the user in to return tokens
      const loginResult = await loginUser({ email, password: randomPassword });
      return res.status(200).json({ message: 'Google fallback registration successful', ...loginResult });
    }

    return res.status(400).json({ message: 'Either idToken or email is required' });
  } catch (error: any) {
    return res.status(400).json({ message: error.message || "Google auth failed" });
  }
};

/* =======================
   REGISTER (GOOGLE COMPLETE)
   POST /auth/register-google { idToken? | email, username?, name? }
   Creates a user (with generated password) using Google-provided email and chosen username/name,
   returns tokens so frontend can treat the user as signed-in.
======================= */
export const registerGoogle = async (req: Request, res: Response) => {
  try {
    const { idToken, email, username, name } = req.body as { idToken?: string; email?: string; username?: string; name?: string };

    // If idToken provided, reuse googleSignIn which handles idToken decoding and creation
    if (idToken) {
      const result = await googleSignIn(idToken, { username, name });
      return res.status(200).json({ message: 'Google registration successful', ...result });
    }

    if (!email) return res.status(400).json({ message: 'email is required' });

    // If user already exists, return conflict
    const existing = await prisma.users.findUnique({ where: { email }, select: { user_id: true } });
    if (existing) return res.status(409).json({ message: 'User already exists' });

    // create with generated password
    const randomPassword = Math.random().toString(36) + Date.now().toString(36);
    const created = await registerUser({ name: name || email.split('@')[0], email, password: randomPassword, username });

    // login to return tokens
    const loginResult = await loginUser({ email, password: randomPassword });
    return res.status(201).json({ message: 'Google registration successful', ...loginResult });
  } catch (error: any) {
    return res.status(400).json({ message: error.message || 'Google registration failed' });
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
