import express from 'express';
import { json } from 'body-parser';
import routes from './routes';
import meRoutes from './routes/me.routes';
import { startPurgeJob } from './jobs/purgeJob';

const app = express();
const PORT = 3000;

// Middleware
app.use(json());

// Register general routes under /api
app.use('/api', routes);

// Register /me routes under /api/me
app.use('/api/me', meRoutes);

// Start server
app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
    // start background purge job with default 30-day grace period
    startPurgeJob(30);
});
