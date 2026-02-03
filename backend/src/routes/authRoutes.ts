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

// POST /auth/login
router.post("/login", login);

// POST /auth/refresh  ✅ STEP 3.7
router.post("/refresh", refresh);

export default router;
