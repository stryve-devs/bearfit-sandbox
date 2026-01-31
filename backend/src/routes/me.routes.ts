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

export default router;
