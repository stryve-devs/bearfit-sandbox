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
        // Ensure Redis is connected before starting the server
        await connectRedis();
    } catch (err) {
        console.error('Failed to connect to Redis, aborting startup.', err);
        process.exit(1);
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
