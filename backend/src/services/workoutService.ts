import prisma from "../config/prismaClient";

export const createWorkout = async (userId: number, payload: any) => {
  if (!payload) throw new Error("Missing payload");

  const clientId = payload.client_id ?? null;

  if (clientId) {
    // Check if entry already exists (client-generated id from offline device)
    const existing = await prisma.workouts.findFirst({ where: { user_id: userId, client_id: clientId } });
    if (existing) return { workout: existing, created: false };
  }

  // Build create object (whitelist fields)
  const data: any = { user_id: userId };
  if (clientId) data.client_id = clientId;
  if (payload.date) data.date = payload.date;
  if (payload.type) data.type = payload.type;
  if (payload.duration_minutes) data.duration_minutes = payload.duration_minutes;
  if (payload.calories_burned) data.calories_burned = payload.calories_burned;
  if (payload.notes) data.notes = payload.notes;

  try {
    const workout = await prisma.workouts.create({ data });
    return { workout, created: true };
  } catch (err: any) {
    // If a unique constraint race occurred (another process created same client_id concurrently), return existing
    if (err?.code === "P2002") {
      const existing = await prisma.workouts.findFirst({ where: { user_id: userId, client_id: clientId } });
      if (existing) return { workout: existing, created: false };
    }
    throw err;
  }
};

export const getWorkoutsForUser = async (userId: number) => {
  return prisma.workouts.findMany({ where: { user_id: userId }, orderBy: { date: "desc" } });
};
