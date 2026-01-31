import prisma from "../config/prismaClient";

export const exportUserData = async (id: number) => {
  return prisma.users.findUnique({
    where: { user_id: id },
    include: { workouts: true, meals: true, progress: true, refresh_tokens: true },
  });
};

export const toCSV = (data: any) => {
  if (!data) return "";
  // Flatten top-level scalar fields and JSON-stringify arrays/objects
  const rows = Object.entries(data).map(([k, v]) => `${k},${JSON.stringify(v)}`);
  return `key,value\n${rows.join("\n")}`;
};

export const getUserById = async (id: number) => {
  return prisma.users.findUnique({ where: { user_id: id } });
};

export const updateUser = async (id: number, payload: Record<string, any>) => {
  const allowed: Record<string, any> = {};
  // whitelist fields that can be updated
  if (payload.email) allowed.email = payload.email;
  if (payload.name) allowed.name = payload.name;
  if (payload.username) allowed.username = payload.username;
  if (payload.gender) allowed.gender = payload.gender;
  if (payload.date_of_birth) allowed.date_of_birth = payload.date_of_birth;

  if (Object.keys(allowed).length === 0) {
    throw new Error("No updatable fields provided");
  }

  return prisma.users.update({ where: { user_id: id }, data: allowed });
};

export const softDeleteUser = async (id: number) => {
  return prisma.users.update({
    where: { user_id: id },
    data: {
      is_active: false,
      email_verified: false,
      deleted_at: new Date(),
    },
  });
};

export const revokeRefreshTokensForUser = async (id: number) => {
  return prisma.refresh_tokens.updateMany({
    where: { user_id: id, revoked: false },
    data: { revoked: true },
  });
};

export const purgeDeletedUsers = async (graceDays = 30) => {
  const cutoff = new Date(Date.now() - graceDays * 24 * 60 * 60 * 1000);
  // find users soft-deleted before cutoff
  const toPurge = await prisma.users.findMany({ where: { is_active: false, deleted_at: { lte: cutoff } } });

  const userIds = toPurge.map((u) => u.user_id);
  if (userIds.length === 0) return { deleted: 0 };

  // delete related refresh tokens first
  await prisma.refresh_tokens.deleteMany({ where: { user_id: { in: userIds } } });

  // delete users
  const res = await prisma.users.deleteMany({ where: { user_id: { in: userIds } } });
  return { deleted: res.count };
};
