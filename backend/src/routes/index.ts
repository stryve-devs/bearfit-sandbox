import { Router } from "express";
import authRoutes from "./authRoutes";
import userRoutes from "./userRoutes";

const router = Router();

// Auth routes
router.use("/auth", authRoutes);

// User routes (protected)
router.use("/users", userRoutes);

export default router;
