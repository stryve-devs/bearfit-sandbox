import { Router } from "express";
import { authenticate } from "../middlewares/authMiddleware";

const router = Router();

router.get("/me", authenticate, (req, res) => {
  res.json({
    message: "Protected route",
    user: req.user,
  });
});

export default router;
