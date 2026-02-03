import { Router } from "express";
import authRoutes from "./authRoutes";
import userRoutes from "./userRoutes";
import meRoutes from "./me.routes";

const router = Router();

// Auth routes
router.use("/auth", authRoutes);

// User routes (protected)
router.use("/users", userRoutes);

// Me routes (protected)
router.use("/me", meRoutes);

export default router;
