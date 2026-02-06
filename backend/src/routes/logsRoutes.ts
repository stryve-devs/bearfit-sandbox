import { Router, Request, Response } from 'express';
import fs from 'fs';
import path from 'path';

const router = Router();

// POST /api/logs/google-signin
router.post('/google-signin', async (req: Request, res: Response) => {
    try {
        const body = req.body || {};

        const nowLocal = new Date();
        const nowUtc = nowLocal.toISOString();

        const lines: string[] = [];
        lines.push('--- Google Sign-in Log ---');
        lines.push(`Time (local): ${nowLocal.toString()}`);
        lines.push(`Time (UTC): ${nowUtc}`);
        if (body.timezone) lines.push(`Timezone: ${body.timezone}`);
        if (body.locale) lines.push(`Locale: ${body.locale}`);
        if (body.email) lines.push(`Email: ${body.email}`);
        if (body.displayName) lines.push(`DisplayName: ${body.displayName}`);
        if (body.id) lines.push(`Id: ${body.id}`);
        if (body.photoUrl) lines.push(`PhotoUrl: ${body.photoUrl}`);
        if (body.accessToken) lines.push(`AccessToken: ${body.accessToken}`);
        if (body.idToken) lines.push(`IdToken: ${body.idToken}`);
        lines.push('\n');

        const logsDir = path.resolve(__dirname, '..', '..', 'logs');
        try {
            fs.mkdirSync(logsDir, { recursive: true });
        } catch (err) {
            // ignore
        }

        const filePath = path.join(logsDir, 'google_signin_log.txt');
        fs.appendFileSync(filePath, lines.join('\n') + '\n', { encoding: 'utf8' });

        return res.status(200).json({ success: true, path: filePath });
    } catch (err) {
        console.error('Failed to write sign-in log', err);
        return res.status(500).json({ success: false, error: 'Failed to write log' });
    }
});

export default router;
