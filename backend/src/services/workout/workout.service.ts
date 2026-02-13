import prisma from "../../config/prismaClient";

export const createWorkout = async (userId: number, payload: any) => {
  if (!payload) throw new Error("Missing payload");

  // Build create object (whitelist fields)
  const data: any = { user_id: userId };
  if (payload.date) data.date = payload.date;
  if (payload.type) data.type = payload.type;
  if (payload.duration_minutes) data.duration_minutes = payload.duration_minutes;
  if (payload.calories_burned) data.calories_burned = payload.calories_burned;
  if (payload.notes) data.notes = payload.notes;

  const workout = await prisma.workouts.create({ data });
  return { workout, created: true };
};

export const getWorkoutsForUser = async (userId: number) => {
  return prisma.workouts.findMany({ where: { user_id: userId }, orderBy: { date: "desc" } });
};
