import fs from 'fs';
import path from 'path';

// Small helper script to generate a sample auth config for local development.
const config = {
  jwtSecret: process.env.JWT_SECRET || 'dev-secret',
};

const out = path.join(process.cwd(), 'auth-config.json');
fs.writeFileSync(out, JSON.stringify(config, null, 2));
console.log('Wrote', out);
