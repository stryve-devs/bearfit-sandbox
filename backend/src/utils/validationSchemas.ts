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
const googleAuthBase = z.object({
  username: z.string().min(3, 'Username must be at least 3 characters').max(150, 'Username too long').optional(),
  name: z.string().min(1, 'Name is required').max(150, 'Name too long').optional(),
});

// Accept either an ID token (from Google) or an email fallback (when idToken isn't available on the client)
export const googleAuthSchema = z.union([
  googleAuthBase.extend({ idToken: z.string().min(1, 'ID token is required') }),
  googleAuthBase.extend({ email: z.string().email('Invalid email format').min(1, 'Email is required') }),
]);

// Types for TypeScript
export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type RefreshTokenInput = z.infer<typeof refreshTokenSchema>;
export type GoogleAuthInput = z.infer<typeof googleAuthSchema>;

// Workout creation schema (supports optional client-generated ID for offline entries)
export const createWorkoutSchema = z.object({
  client_id: z.string().max(100).optional(),
  date: z.string().optional(),
  type: z.string().max(30).optional(),
  duration_minutes: z.number().optional(),
  calories_burned: z.number().optional(),
  notes: z.string().optional(),
});

export type CreateWorkoutInput = z.infer<typeof createWorkoutSchema>;
