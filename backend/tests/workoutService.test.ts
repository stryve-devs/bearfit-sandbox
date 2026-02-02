import prisma from "../src/config/prismaClient";
import { createWorkout } from "../src/services/workoutService";

jest.mock("../src/config/prismaClient", () => ({
  __esModule: true,
  default: {
    workouts: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
  },
}));

const mockPrisma: any = prisma as any;

describe("workoutService.createWorkout", () => {
  beforeEach(() => {
    mockPrisma.workouts.findFirst.mockReset();
    mockPrisma.workouts.create.mockReset();
  });

  test("returns existing when client_id already exists", async () => {
    mockPrisma.workouts.findFirst.mockResolvedValue({ workout_id: 1, client_id: "abc" });
    const res = await createWorkout(1, { client_id: "abc" });
    expect(res.created).toBe(false);
    expect(res.workout.client_id).toBe("abc");
  });

  test("creates a workout when none exists", async () => {
    mockPrisma.workouts.findFirst.mockResolvedValue(null);
    mockPrisma.workouts.create.mockResolvedValue({ workout_id: 2, client_id: "new" });
    const res = await createWorkout(1, { client_id: "new" });
    expect(res.created).toBe(true);
    expect(res.workout.client_id).toBe("new");
    expect(mockPrisma.workouts.create).toHaveBeenCalled();
  });

  test("on unique constraint error returns existing", async () => {
    mockPrisma.workouts.findFirst.mockResolvedValue({ workout_id: 3, client_id: "race" });
    mockPrisma.workouts.create.mockRejectedValue({ code: "P2002" });
    const res = await createWorkout(1, { client_id: "race" });
    expect(res.created).toBe(false);
    expect(res.workout.client_id).toBe("race");
  });
});
