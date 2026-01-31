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
  });

  if (existingUser) {
    throw new Error("User already exists with this email");
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

  // 1️⃣ Find user
  const user = await prisma.users.findUnique({
    where: { email },
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
    id: user.user_id,
    email: user.email,
    role: user.role,
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
      role: user.role,
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
    id: decoded.id,
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
