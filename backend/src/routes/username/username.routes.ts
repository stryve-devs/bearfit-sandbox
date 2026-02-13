import { Router, Request, Response } from 'express';

const router = Router();

// GET /api/username/exists?username=...
router.get('/exists', async (req: Request, res: Response) => {
  try {
    const username = String(req.query.username || '').trim();
    if (!username) return res.status(400).json({ message: 'username query parameter is required' });

    const prisma = (await import('../../config/prismaClient')).default;
    const user = await prisma.users.findUnique({ where: { username }, select: { user_id: true } });
    return res.status(200).json({ exists: !!user });
  } catch (err) {
    console.error('username exists check failed', err);
    return res.status(500).json({ message: 'Failed to check username' });
  }
});

export default router;
