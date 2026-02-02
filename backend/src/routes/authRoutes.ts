import { Router } from "express";
import { register, login, refresh, googleAuth } from "../controllers/authController";
import { authRateLimiter } from "../middlewares/rateLimitMiddleware";
import { validateRequest } from "../middlewares/validationMiddleware";
import { idempotencyMiddleware } from "../middlewares/idempotencyMiddleware";
import { 
  registerSchema, 
  loginSchema, 
  refreshTokenSchema,
  googleAuthSchema 
} from "../utils/validationSchemas";

const router = Router();

// POST /auth/register - with rate limiting and validation
router.post("/register", authRateLimiter, idempotencyMiddleware, validateRequest(registerSchema), register);

// POST /auth/login - with rate limiting and validation
router.post("/login", authRateLimiter, validateRequest(loginSchema), login);

// POST /auth/refresh - with validation
router.post("/refresh", validateRequest(refreshTokenSchema), refresh);

// POST /auth/google - with rate limiting and validation
router.post("/google", authRateLimiter, validateRequest(googleAuthSchema), googleAuth);

export default router;
