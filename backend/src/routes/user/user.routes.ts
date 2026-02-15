import { Router } from "express";
import { authenticate } from "../../middlewares/auth/authMiddleware";

const router = Router();

router.get("/me", authenticate, (req, res) => {
  res.json({
    message: "Protected route",
    user: (req as any).user,
  });
});

export default router;
