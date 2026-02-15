import { Request, Response, NextFunction } from "express";
import {
  registerUser,
  loginUser,
  refreshAccessToken,
  googleSignIn,
} from "../services/authService";

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
    next(error);
  }
};

/* =======================
   LOGIN
======================= */
export const login = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password } = req.body;

    const result = await loginUser({ email, password });

    return res.status(200).json({
      message: "Login successful",
      ...result,
    });
  } catch (error: any) {
    next(error);
  }
};

/* =======================
   REFRESH TOKEN (STEP 3.7)
======================= */
export const refresh = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { refreshToken } = req.body;

    const tokens = await refreshAccessToken(refreshToken);

    return res.status(200).json({
      message: "Token refreshed successfully",
      ...tokens,
    });
  } catch (error: any) {
    next(error);
  }
};

/* =======================
   GOOGLE AUTH
   POST /auth/google
   body: { idToken }
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
    return res.status(401).json({ message: error.message || "Google sign-in failed" });
  }
};
