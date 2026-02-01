import { z } from 'zod';

// Register validation schema
export const registerSchema = z.object({
  name: z.string().min(1, 'Name is required').max(150, 'Name too long'),
  email: z.string().email('Invalid email format').max(320, 'Email too long'),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .max(100, 'Password too long')
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      'Password must contain at least one uppercase letter, one lowercase letter, and one number'
    ),
  username: z.string().min(3, 'Username must be at least 3 characters').max(150, 'Username too long').optional(),
});

// Login validation schema
export const loginSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(1, 'Password is required'),
});

// Refresh token validation schema
export const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

// Google auth validation schema
export const googleAuthSchema = z.object({
  idToken: z.string().min(1, 'ID token is required'),
});

// Types for TypeScript
export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type RefreshTokenInput = z.infer<typeof refreshTokenSchema>;
export type GoogleAuthInput = z.infer<typeof googleAuthSchema>;
