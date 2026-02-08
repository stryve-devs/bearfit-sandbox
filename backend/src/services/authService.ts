import prisma from "../config/prismaClient";
import { hashPassword, comparePassword } from "../utils/passwordUtils";
import {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
  JwtPayload,
} from "../utils/jwtUtils";

/* =======================
   REGISTER
======================= */

interface RegisterInput {
  name: string;
  email: string;
  password: string;
  username?: string;
}

export const registerUser = async (data: RegisterInput) => {
  const { name, email, password, username } = data;

  // 1️⃣ Check if user already exists
  const existingUser = await prisma.users.findUnique({
    where: { email },
    select: { user_id: true },
  });

  if (existingUser) {
    throw new Error("User exists");
  }

  // 2️⃣ Hash password
  const hashedPassword = await hashPassword(password);

  // 3️⃣ Create user
  const user = await prisma.users.create({
    data: {
      name,
      email,
      password_hash: hashedPassword,
      username,
    },
    select: {
      user_id: true,
      name: true,
      email: true,
      username: true,
      created_at: true,
    },
  });

  return user;
};

/* =======================
   LOGIN
======================= */

interface LoginInput {
  email: string;
  password: string;
}

export const loginUser = async (data: LoginInput) => {
  const { email, password } = data;

  // 1️⃣ Find user (select only needed fields to avoid enum conversion issues)
  const user = await prisma.users.findUnique({
    where: { email },
    select: {
      user_id: true,
      name: true,
      email: true,
      username: true,
      password_hash: true,
      is_active: true,
    },
  });

  if (!user || !user.is_active) {
    throw new Error("Invalid email or password");
  }

  // 2️⃣ Compare password
  const isValidPassword = await comparePassword(
    password,
    user.password_hash
  );

  if (!isValidPassword) {
    throw new Error("Invalid email or password");
  }

  // 3️⃣ JWT payload
  const payload: JwtPayload = {
    userId: user.user_id,
    email: user.email,
    // DB role column is currently stored as a DB enum which isn't mapped in the Prisma schema.
    // Use a safe default role here until the schema/DB are aligned.
    role: 'USER',
  };

  // 4️⃣ Generate tokens
  const accessToken = generateAccessToken(payload);
  const refreshToken = generateRefreshToken(payload);

  // 5️⃣ Store refresh token in DB
  await prisma.refresh_tokens.create({
    data: {
      token: refreshToken,
      user_id: user.user_id,
      expires_at: new Date(
        Date.now() + 7 * 24 * 60 * 60 * 1000 // 7 days
      ),
    },
  });

  // 6️⃣ Return response
  return {
    accessToken,
    refreshToken,
    user: {
      user_id: user.user_id,
      name: user.name,
      email: user.email,
      username: user.username,
      role: 'USER',
    },
  };
};

/* =======================
   REFRESH TOKEN (STEP 3.7)
======================= */

export const refreshAccessToken = async (refreshToken: string) => {
  // 1️⃣ Verify refresh token cryptographically
  const decoded = verifyRefreshToken(refreshToken);

  // 2️⃣ Find refresh token in DB
  const storedToken = await prisma.refresh_tokens.findUnique({
    where: { token: refreshToken },
  });

  if (!storedToken || storedToken.revoked) {
    throw new Error("Invalid refresh token");
  }

  // 3️⃣ Check expiry
  if (storedToken.expires_at < new Date()) {
    throw new Error("Refresh token expired");
  }

  // 4️⃣ Revoke old refresh token (rotation)
  await prisma.refresh_tokens.update({
    where: { id: storedToken.id },
    data: { revoked: true },
  });

  // 5️⃣ Create new JWT payload
  const payload: JwtPayload = {
    userId: decoded.userId,
    email: decoded.email,
    role: decoded.role,
  };

  // 6️⃣ Generate new tokens
  const newAccessToken = generateAccessToken(payload);
  const newRefreshToken = generateRefreshToken(payload);

  // 7️⃣ Store new refresh token
  await prisma.refresh_tokens.create({
    data: {
      token: newRefreshToken,
      user_id: storedToken.user_id,
      expires_at: new Date(
        Date.now() + 7 * 24 * 60 * 60 * 1000 // 7 days
      ),
    },
  });

  return {
    accessToken: newAccessToken,
    refreshToken: newRefreshToken,
  };
};

/* =======================
   GOOGLE SIGN-IN
   Minimal implementation: decodes ID token payload without verification,
   finds or creates a user by email, and returns tokens.
   NOTE: For production verify the ID token with Google's APIs.
======================= */

export const googleSignIn = async (idToken: string, opts?: { username?: string; name?: string }) => {
  if (!idToken) throw new Error('idToken is required');

  // naive JWT payload decode (no verification!)
  const parts = idToken.split('.');
  if (parts.length < 2) throw new Error('Invalid idToken format');
  const payload = JSON.parse(Buffer.from(parts[1].replace(/-/g, '+').replace(/_/g, '/'), 'base64').toString('utf8'));

  const email: string | undefined = payload.email;
  const tokenName: string | undefined = payload.name || payload.given_name;

  if (!email) throw new Error('Google token does not contain an email');

  // find or create user (select only necessary fields to keep types consistent)
  let user = await prisma.users.findUnique({
    where: { email },
    select: { user_id: true, name: true, email: true, username: true },
  });
  if (!user) {
    // If a username was provided, ensure it's not already taken
    if (opts?.username) {
      const existingByUsername = await prisma.users.findUnique({ where: { username: opts.username }, select: { user_id: true } });
      if (existingByUsername) {
        throw new Error('Username already taken');
      }
    }

    const randomPassword = Math.random().toString(36) + Date.now().toString(36);
    const hashedPassword = await hashPassword(randomPassword);
    user = await prisma.users.create({
      data: {
        name: opts?.name || tokenName || email.split('@')[0],
        email,
        password_hash: hashedPassword,
        username: opts?.username,
      },
      select: {
        user_id: true,
        name: true,
        email: true,
        username: true,
        created_at: true,
      },
    });
  }

  const payloadJwt: JwtPayload = {
    userId: user.user_id,
    email: user.email,
    role: 'USER',
  };

  const accessToken = generateAccessToken(payloadJwt);
  const refreshToken = generateRefreshToken(payloadJwt);

  await prisma.refresh_tokens.create({
    data: {
      token: refreshToken,
      user_id: user.user_id,
      expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    },
  });

  return {
    accessToken,
    refreshToken,
    user: {
      user_id: user.user_id,
      name: user.name,
      email: user.email,
      username: user.username,
      role: 'USER',
    },
  };
};
