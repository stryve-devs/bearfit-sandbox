import { Request, Response } from "express";
import { createWorkout as createWorkoutService } from "../services/workoutService";

export const createWorkout = async (req: Request, res: Response) => {
  const userId = (req as any).user?.user_id;
  if (!userId) return res.status(401).json({ message: "Unauthorized" });

  const payload = req.body;
  try {
    const { workout, created } = await createWorkoutService(userId, payload);
    if (!created) return res.status(200).json(workout);
    return res.status(201).json(workout);
  } catch (err: any) {
    console.error("Error creating workout:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
};
