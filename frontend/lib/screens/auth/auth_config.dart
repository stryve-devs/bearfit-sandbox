// GENERATED FILE - DO NOT EDIT BY HAND
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

const String googleAndroidClientId = '863592591549-79r5fj14cduf6dr98310lesoi3gj8k19.apps.googleusercontent.com';

// Backend host reachable from device. This value is copied from backend/.env
const String backendHost = "http://192.168.0.130:3000";
