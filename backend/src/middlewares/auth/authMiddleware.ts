import { Request, Response, NextFunction } from "express";
import { verifyAccessToken, JwtPayload } from "../../utils/jwtUtils";
import prisma from '../../config/prismaClient';

export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = String(req.headers.authorization || '');
    if (!authHeader.startsWith('Bearer ')) return res.status(401).json({ message: 'Missing Bearer token' });
    const token = authHeader.slice(7).trim();
    const payload = verifyAccessToken(token) as JwtPayload;
    // attach to request or validate further
    (req as any).user = payload;
    return next();
  } catch (err: any) {
    return res.status(401).json({ message: err?.message || 'Invalid token' });
  }
};
