import 'dotenv/config';
import express from 'express';
import { json } from 'body-parser';
import routes from './routes';
import corsConfig from './config/corsConfig';
import { startPurgeJob } from './jobs/purgeJob';
import { connectRedis } from './config/redisClient';

const app = express();
const PORT = process.env.PORT ? Number(process.env.PORT) : 3000;

// Middleware
app.use(json());
app.use(corsConfig);

// Routes
app.use('/api', routes);

const start = async () => {
    try {
        // Try to connect to Redis but don't abort startup if Redis is unavailable.
        // This makes local development and testing easier when Redis isn't running.
        await connectRedis();
    } catch (err) {
        console.warn('Warning: Failed to connect to Redis. Continuing without Redis.', err);
    }

    // Start background jobs
    startPurgeJob();

    // Start server and bind to 0.0.0.0 so it is reachable from other devices on the LAN
    const HOST = process.env.HOST || '0.0.0.0';
    app.listen(PORT, HOST, () => {
        console.log(`Server is running at http://${HOST}:${PORT}`);
    });
};

start();
