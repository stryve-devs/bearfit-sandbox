import { Router } from "express";
import authRoutes from "./auth/auth.routes";
import { authenticate } from "../middlewares/auth/authMiddleware";
import userRoutes from "./user/user.routes";
import meRoutes from "./me/me.routes";
import logsRoutes from "./logs/logs.routes";
import usernameRoutes from "./username/username.routes";

const router = Router();

// Auth routes
router.use("/auth", authRoutes);
// Auth routes
router.use("/auth", authRoutes);

// Public routes (no auth required)
router.use('/username', usernameRoutes);
// Logs (accept sign-in logs)
router.use('/logs', logsRoutes);

// Protect all subsequent routes with access-token authentication
router.use(authenticate);

// User routes (protected)
router.use("/users", userRoutes);

// Me routes (protected)
router.use("/me", meRoutes);

export default router;
