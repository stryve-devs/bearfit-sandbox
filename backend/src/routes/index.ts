import { Router } from "express";
import authRoutes from "./authRoutes";
import userRoutes from "./userRoutes";
import meRoutes from "./me.routes";
import logsRoutes from "./logsRoutes";
import usernameRoutes from "./usernameRoutes";

const router = Router();

// Auth routes
router.use("/auth", authRoutes);

// User routes (protected)
router.use("/users", userRoutes);

// Me routes (protected)
router.use("/me", meRoutes);

// Logs (accept sign-in logs)
router.use('/logs', logsRoutes);

// Username routes
router.use('/username', usernameRoutes);

export default router;
