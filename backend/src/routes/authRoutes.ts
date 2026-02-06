import { Router } from "express";
import { register, login, refresh, googleAuth, checkEmailExists } from "../controllers/authController";
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

// POST /auth/login - rate limited, idempotent, validated
router.post("/login", authRateLimiter, idempotencyMiddleware, validateRequest(loginSchema), login);

// POST /auth/refresh  ✅ STEP 3.7
router.post("/refresh", refresh);

// POST /auth/google - Google ID token sign-in
router.post("/google", idempotencyMiddleware, validateRequest(googleAuthSchema), googleAuth);

// GET /auth/exists?email=... - check whether email is already registered
router.get('/exists', checkEmailExists);

export default router;
