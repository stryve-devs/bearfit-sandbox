import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

// Load backend .env (this script should be run from backend/)
dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const webClientId = process.env.GOOGLE_CLIENT_ID_WEB || '';
const backendHost = process.env.BACKEND_HOST || '';

const outPath = path.resolve(process.cwd(), '..', 'frontend', 'lib', 'screens', 'auth', 'auth_config.dart');

const content = `// GENERATED FILE - DO NOT EDIT BY HAND
// This file is generated from backend/.env by src/scripts/generateAuthConfig.ts
//
// Purpose:
// - Expose Google client IDs and the backend host to the Flutter frontend.
// - The backend host is used by the frontend to POST sign-in logs to
//   the backend endpoint (/api/logs/google-signin).
//
// Developer notes:
// - Update the backend host in backend/.env (BACKEND_HOST) to the IP reachable
//   from real test devices (e.g. http://192.168.0.130:3000).
// - Run 'npm run generate:frontend-config' from the backend folder to regenerate
//   this file whenever you change values in backend/.env.

const String googleAndroidClientId = '${webClientId}';

// Backend host reachable from device. This value is copied from backend/.env
const String backendHost = '${backendHost}';
`;

try {
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, content, { encoding: 'utf8' });
  console.log(`Wrote frontend auth config to ${outPath}`);
} catch (err) {
  console.error('Failed to write auth config:', err);
  process.exit(1);
}
