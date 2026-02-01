# Backend Security Implementation

## ✅ Completed Tasks

### 1. Redis Rate Limiting for Login/Register
- Added Redis-based rate limiting using `express-rate-limit` and `rate-limit-redis`
- Auth routes (login/register/google) limited to **5 requests per 15 minutes** per IP
- Rate limit info exposed in response headers

### 2. Input Validation using Zod
- Implemented Zod schemas for all auth endpoints
- Validation includes:
  - **Register**: Email format, password strength (min 8 chars, uppercase, lowercase, number), name/username length
  - **Login**: Email format, required fields
  - **Refresh**: Token presence
  - **Google Auth**: ID token presence
- Returns detailed validation errors with field names

### 3. Secure CORS Setup and Error Handling
- CORS configured with whitelisted origins
- Credentials support enabled for cookies
- Rate limit headers exposed
- Centralized error handling middleware
- JWT error handling (expired/invalid tokens)
- Development-friendly error messages with stack traces

## 📁 Files Created/Modified

**Created:**
- `src/config/redisClient.ts` - Redis connection
- `src/config/corsConfig.ts` - CORS configuration
- `src/middlewares/rateLimitMiddleware.ts` - Rate limiting
- `src/middlewares/validationMiddleware.ts` - Zod validation wrapper
- `src/middlewares/errorMiddleware.ts` - Error handling
- `src/utils/validationSchemas.ts` - Zod schemas

**Modified:**
- `src/routes/authRoutes.ts` - Added middleware to routes
- `src/controllers/authController.ts` - Simplified (validation moved to middleware)
- `src/server.ts` - Added CORS, error handlers
- `.env.example` - Added Redis and CORS config

## 🚀 Setup Instructions

### 1. Install Redis Locally

**Windows (using WSL or Docker):**
```bash
# Using Docker (recommended)
docker run -d -p 6379:6379 redis:alpine

# Or using WSL
sudo apt install redis-server
redis-server
```

### 2. Update Environment Variables

Copy your existing `.env` or update `.env.example`:
```env
# Add these lines to your .env file
REDIS_URL=redis://localhost:6379
NODE_ENV=development
FRONTEND_URL=http://localhost:8081
```

### 3. Start the Server

```bash
npm run dev
```

## 🧪 Testing

### Test Rate Limiting

Try registering 6 times quickly:
```bash
# First 5 requests will work
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "Password123"
  }'

# 6th request will be rate limited
# Response: {"message": "Too many authentication attempts, please try again later."}
```

### Test Input Validation

**Invalid email:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test",
    "email": "invalid-email",
    "password": "Password123"
  }'

# Response: {"message": "Validation failed", "errors": [{"field": "email", "message": "Invalid email format"}]}
```

**Weak password:**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test",
    "email": "test@example.com",
    "password": "weak"
  }'

# Response: Validation error about password requirements
```

### Test CORS

```bash
# From allowed origin - works
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost:8081" \
  -d '{"email": "test@example.com", "password": "Password123"}'

# From disallowed origin - blocked by CORS
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Origin: http://malicious-site.com" \
  -d '{"email": "test@example.com", "password": "Password123"}'
```

## 📊 Rate Limit Headers

When rate limiting is active, you'll see these headers:
```
RateLimit-Limit: 5
RateLimit-Remaining: 4
RateLimit-Reset: 1675123456
```

## 🔧 Configuration

### Adjust Rate Limits

Edit [`src/middlewares/rateLimitMiddleware.ts`](src/middlewares/rateLimitMiddleware.ts):
```typescript
windowMs: 15 * 60 * 1000, // 15 minutes
max: 5, // Maximum 5 requests
```

### Add Allowed Origins

Edit [`src/config/corsConfig.ts`](src/config/corsConfig.ts):
```typescript
const allowedOrigins = [
  'http://localhost:3000',
  'http://localhost:8081',
  'https://yourdomain.com', // Add production domain
];
```

### Customize Validation Rules

Edit [`src/utils/validationSchemas.ts`](src/utils/validationSchemas.ts):
```typescript
password: z.string()
  .min(8, 'Password must be at least 8 characters')
  .max(100, 'Password too long')
  .regex(/your-pattern/, 'Your error message')
```

## 🛡️ Security Best Practices

1. **Never commit `.env` file** - It's in `.gitignore`
2. **Use strong JWT secrets** - Generate with: `node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"`
3. **Keep Redis password protected** in production
4. **Update CORS origins** for production
5. **Monitor rate limit logs** for suspicious activity
6. **Use HTTPS** in production

## 📝 Next Steps

Consider adding:
- [ ] Account lockout after failed login attempts
- [ ] Email verification rate limiting
- [ ] Password reset rate limiting
- [ ] Distributed rate limiting for multi-server setups
- [ ] Redis authentication for production
- [ ] Helmet.js for additional security headers
- [ ] Request logging and monitoring
