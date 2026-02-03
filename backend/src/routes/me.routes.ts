import { Router } from "express";
import { getMe, updateMe, exportMe } from "../controllers/me.controller";
import { authenticate } from "../middlewares/authMiddleware";

const router = Router();

router.get("/", authenticate, getMe);
router.patch("/", authenticate, updateMe);
router.get("/export", authenticate, exportMe);  // <-- New export route
router.delete("/", authenticate, async (req, res) => {
	// lazy-load to avoid circular imports at module init
	const { deleteMe } = await import("../controllers/me.controller");
	return deleteMe(req, res);
});

// Workouts - supports client-generated `client_id` and idempotency (Idempotency-Key header)
import { createWorkout } from "../controllers/workoutController";
import { idempotencyMiddleware } from "../middlewares/idempotencyMiddleware";
import { validateRequest } from "../middlewares/validationMiddleware";
import { createWorkoutSchema } from "../utils/validationSchemas";

router.post("/workouts", authenticate, idempotencyMiddleware, validateRequest(createWorkoutSchema), createWorkout);
router.get("/workouts", authenticate, async (req, res) => {
	const userId = (req as any).user?.user_id;
	if (!userId) return res.status(401).json({ message: "Unauthorized" });
	const workouts = await (await import("../services/workoutService")).getWorkoutsForUser(userId);
	return res.json(workouts);
});

export default router;
