import { Router } from "express";
import { register, login, refresh } from "../controllers/authController";

const router = Router();

// POST /auth/register
router.post("/register", register);

// POST /auth/login
router.post("/login", login);

// POST /auth/refresh  ✅ STEP 3.7
router.post("/refresh", refresh);

export default router;
