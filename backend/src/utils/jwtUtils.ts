import jwt, { SignOptions } from "jsonwebtoken";

/**
 * Secrets (must come from environment variables)
 */
const ACCESS_TOKEN_SECRET = process.env.JWT_ACCESS_SECRET as string;
const REFRESH_TOKEN_SECRET = process.env.JWT_REFRESH_SECRET as string;

/**
 * Expiry configuration
 */
const ACCESS_TOKEN_EXPIRES_IN =
  (process.env.JWT_ACCESS_EXPIRES_IN as SignOptions["expiresIn"]) || "15m";

const REFRESH_TOKEN_EXPIRES_IN =
  (process.env.JWT_REFRESH_EXPIRES_IN as SignOptions["expiresIn"]) || "7d";

/**
 * Fail fast if secrets are missing
 * (important for both dev and prod)
 */
if (!ACCESS_TOKEN_SECRET || !REFRESH_TOKEN_SECRET) {
  throw new Error("JWT secrets are not defined in environment variables");
}

/**
 * JWT Payload interface
 * This is what will be attached to req.user
 */
export interface JwtPayload {
  userId: number;
  email: string;
  role: string;
}

/**
 * 🔐 Generate Access Token
 */
export const generateAccessToken = (payload: JwtPayload): string => {
  return jwt.sign(payload, ACCESS_TOKEN_SECRET, {
    expiresIn: ACCESS_TOKEN_EXPIRES_IN,
  });
};

/**
 * 🔁 Generate Refresh Token
 */
export const generateRefreshToken = (payload: JwtPayload): string => {
  return jwt.sign(payload, REFRESH_TOKEN_SECRET, {
    expiresIn: REFRESH_TOKEN_EXPIRES_IN,
  });
};

/**
 * ✅ Verify Access Token
 */
export const verifyAccessToken = (token: string): JwtPayload => {
  return jwt.verify(token, ACCESS_TOKEN_SECRET) as JwtPayload;
};

/**
 * ✅ Verify Refresh Token
 */
export const verifyRefreshToken = (token: string): JwtPayload => {
  return jwt.verify(token, REFRESH_TOKEN_SECRET) as JwtPayload;
};
