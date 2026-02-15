import { Router } from "express";
import { authenticate } from "../../middlewares/auth/authMiddleware";
import { createWorkout } from "../../controllers/workout/workout.controller";

const router = Router();

router.post('/', authenticate, createWorkout);

export default router;
