import express from 'express';
import { json } from 'body-parser';
import routes from './routes';
import meRoutes from './routes/me.routes';
import { startPurgeJob } from './jobs/purgeJob';
import corsMiddleware from './config/corsConfig';
import { errorHandler, notFoundHandler } from './middlewares/errorMiddleware';
import 'dotenv/config';

const app = express();
const PORT = process.env.PORT || 3000;

// Apply CORS middleware first
app.use(corsMiddleware);

// Body parser middleware
app.use(json());

// Register general routes under /api
app.use('/api', routes);

// Register /me routes under /api/me
app.use('/api/me', meRoutes);

// 404 handler - must be after all routes
app.use(notFoundHandler);

// Error handling middleware - must be last
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
    // start background purge job with default 30-day grace period
    startPurgeJob(30);
});
