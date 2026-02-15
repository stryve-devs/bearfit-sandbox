# Idempotency & Client-generated IDs

This change introduces two features:

1. Client-generated IDs on entries (e.g., `workouts.client_id`) to support offline-created entries being synced from clients. The database now contains a `client_id` optional field on `workouts` with a unique constraint per user (`@@unique([user_id, client_id])`).

2. Idempotency key tracking via a new `idempotency_keys` model. Use the `Idempotency-Key` HTTP header for write operations (POST/PUT/PATCH/DELETE). The middleware will:
   - Return a stored response if a previous request with same key and path completed
   - Prevent duplicate creation when the same `Idempotency-Key` is submitted multiple times

How to apply the database changes:

1. Install prisma dev dependencies if not installed

   npm install

2. Generate a new migration and apply it locally:

   npx prisma migrate dev --name add-clientid-idempotency

3. Generate the Prisma client:

   npx prisma generate

Middleware usage:

- For authenticated routes, add `authenticate` then `idempotencyMiddleware` in the route handler chain (so user id is available to the middleware). For unauthenticated endpoints that should be idempotent (e.g., `/auth/register`), the key will be registered with a `null` user and will still prevent accidental duplicates.

Example headers:

  Idempotency-Key: <uuid-v4>

cURL example (create workout with client-generated id):

```sh
curl -X POST "http://localhost:3000/api/me/workouts" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: 1a2b3c4d-..." \
  -d '{ "client_id": "offline-123", "date": "2026-02-02", "type": "run", "duration_minutes": 30 }'
```

Notes:

- Responses are cached in the `idempotency_keys` row (status, body, headers) and returned for identical idempotency key + path + user.
- This implementation stores the full JSON response body; if you return very large bodies, consider storing only a reference or a subset.

