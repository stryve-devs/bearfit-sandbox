import prisma from "../config/prismaClient";
import { hashPassword, comparePassword } from "../utils/passwordUtils";
import {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
  JwtPayload,
} from "../utils/jwtUtils";
import { OAuth2Client } from "google-auth-library";
import { randomBytes } from "crypto";

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

/* =======================
   GOOGLE SIGN-IN / SIGN-UP
   Single endpoint: accept Google ID token, verify, then find-or-create user
======================= */

export const googleSignIn = async (idToken: string) => {
  const CLIENT_IDS_ENV = [process.env.GOOGLE_CLIENT_IDS, process.env.GOOGLE_CLIENT_ID, process.env.GOOGLE_CLIENT_ID_WEB]
    .filter(Boolean)
    .join(",");
  const CLIENT_IDS = CLIENT_IDS_ENV.split(",").map((s) => s.trim()).filter(Boolean);
  if (CLIENT_IDS.length === 0) throw new Error("Google client ID(s) are not configured");

  // The google-auth-library `verifyIdToken` accepts `audience` as string | string[]
  const client = new OAuth2Client();
  const ticket = await client.verifyIdToken({ idToken, audience: CLIENT_IDS });
  const payload = ticket.getPayload();

  if (!payload || !payload.email) {
    throw new Error("Invalid Google ID token");
  }

  const email = payload.email;
  const name = payload.name || "";

  // 1️⃣ Find existing user by email
  // Use a loose type because we may assign a partial selection later.
  let user: any = await prisma.users.findUnique({ where: { email } });

  // 2️⃣ If user doesn't exist, create one
  if (!user) {
    // generate a random password and hash it to satisfy schema
    const randomPassword = randomBytes(32).toString("hex");
    const hashedPassword = await hashPassword(randomPassword);

    // derive a safe username from email local part
    const baseUsername = email.split("@")[0].replace(/[^a-zA-Z0-9_.-]/g, "").slice(0, 150) || undefined;
    let usernameToUse: string | undefined = baseUsername;

    // ensure username uniqueness
    if (usernameToUse) {
      let suffix = 0;
      while (await prisma.users.findUnique({ where: { username: usernameToUse } })) {
        suffix += 1;
        usernameToUse = `${baseUsername}${suffix}`.slice(0, 150);
      }
    }

    user = await prisma.users.create({
      data: {
        name,
        email,
        password_hash: hashedPassword,
        username: usernameToUse,
        email_verified: true,
      },
      select: {
        user_id: true,
        name: true,
        email: true,
        username: true,
        role: true,
      },
    });
  }

  if (!user) throw new Error("Unable to create or find user");

  // 3️⃣ JWT payload
  const payloadJwt: JwtPayload = {
    id: user.user_id,
    email: user.email,
    role: user.role,
  };

  // 4️⃣ Generate tokens
  const accessToken = generateAccessToken(payloadJwt);
  const refreshToken = generateRefreshToken(payloadJwt);

  // 5️⃣ Store refresh token
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
      role: user.role,
    },
  };
};
