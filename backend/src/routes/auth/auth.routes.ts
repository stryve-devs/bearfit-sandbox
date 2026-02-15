import { Router } from "express";
import { register, login, refresh, googleAuth, registerGoogle, checkEmailExists, sendOtp, verifyOtp } from "../../controllers/auth/auth.controller";
import { authRateLimiter } from "../../middlewares/auth/rateLimitMiddleware";
import { validateRequest } from "../../middlewares/validationMiddleware";
import { idempotencyMiddleware } from "../../middlewares/idempotencyMiddleware";
import { 
  registerSchema, 
  loginSchema, 
  refreshTokenSchema,
  googleAuthSchema 
} from "../../utils/validationSchemas";

const router = Router();

// POST /auth/register - with rate limiting and validation
router.post("/register", authRateLimiter, idempotencyMiddleware, validateRequest(registerSchema), register);

// POST /auth/login - rate limited, idempotent, validated
router.post("/login", authRateLimiter, idempotencyMiddleware, validateRequest(loginSchema), login);

// POST /auth/refresh  ✅ STEP 3.7
router.post("/refresh", refresh);

// POST /auth/google - Google ID token sign-in
router.post("/google", idempotencyMiddleware, validateRequest(googleAuthSchema), googleAuth);

// POST /auth/register-google - register a Google user after choosing username
router.post("/register-google", idempotencyMiddleware, validateRequest(googleAuthSchema), registerGoogle);

// GET /auth/exists?email=... - check whether email is already registered
router.get('/exists', checkEmailExists);

// POST /auth/send-otp - send a one-time code to email
router.post('/send-otp', sendOtp);

// POST /auth/verify-otp - verify provided code
router.post('/verify-otp', verifyOtp);

export default router;
