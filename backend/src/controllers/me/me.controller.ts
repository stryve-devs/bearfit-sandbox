import { Request, Response } from "express";
import * as meService from "../../services/me/me.service";

export const getMe = async (req: Request, res: Response) => {
  const id = (req as any).user!.userId;
  try {
    const user = await meService.getUserById(id);
    if (!user) return res.status(404).json({ message: "User not found" });
    const { password_hash, ...safeUser } = user as any;
    res.json(safeUser);
  } catch (err: any) {
    console.error('getMe error', err);
    return res.status(500).json({ message: err.message || 'Failed to load user' });
  }
};

export const updateMe = async (req: Request, res: Response) => {
  const id = (req as any).user!.userId;
  const payload = req.body || {};
  try {
    const updated = await meService.updateUser(id, payload);
    const { password_hash, ...safeUser } = updated as any;
    res.json(safeUser);
  } catch (err: any) {
    res.status(400).json({ message: err.message || "Unable to update user" });
  }
};

export const exportMe = async (req: Request, res: Response) => {
  const format = (req.query.format as string) || "json";
  const data = await meService.exportUserData((req as any).user!.userId);

  if (format === "csv") {
    const csv = meService.toCSV(data);
    res.header("Content-Type", "text/csv");
    res.attachment("my-data.csv");
    return res.send(csv);
  }

  res.json(data);
};

export const deleteMe = async (req: Request, res: Response) => {
  const id = (req as any).user!.userId;
  try {
    await meService.softDeleteUser(id);
    await meService.revokeRefreshTokensForUser(id);
    return res.status(204).send();
  } catch (err: any) {
    return res.status(500).json({ message: err.message || "Unable to delete account" });
  }
};
