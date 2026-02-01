import { Router } from "express";
import { register, login, refresh, googleAuth } from "../controllers/authController";

const router = Router();

// POST /auth/register
router.post("/register", register);

// POST /auth/login
router.post("/login", login);

// POST /auth/refresh  ✅ STEP 3.7
router.post("/refresh", refresh);

// POST /auth/google  ✅ Google sign-in
router.post("/google", googleAuth);

export default router;
