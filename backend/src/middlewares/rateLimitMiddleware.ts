import { Request, Response, NextFunction } from "express";

type Entry = { count: number; first: number };
const requests = new Map<string, Entry>();
const WINDOW_MS = 60 * 1000; // 1 minute
const MAX_REQUESTS = 10;

export const authRateLimiter = (req: Request, res: Response, next: NextFunction) => {
  const key = req.ip || req.headers["x-forwarded-for"]?.toString() || "global";
  const now = Date.now();
  const entry = requests.get(key) || { count: 0, first: now };

  if (now - entry.first > WINDOW_MS) {
    entry.count = 1;
    entry.first = now;
  } else {
    entry.count += 1;
  }

  requests.set(key, entry);

  if (entry.count > MAX_REQUESTS) {
    return res.status(429).json({ message: "Too many requests, please try again later." });
  }

  next();
};
