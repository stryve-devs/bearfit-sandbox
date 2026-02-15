import { idempotencyMiddleware } from "../src/middlewares/idempotencyMiddleware";
import prisma from "../src/config/prismaClient";

jest.mock("../src/config/prismaClient", () => ({
  __esModule: true,
  default: {
    idempotency_keys: {
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
  },
}));

const mockPrisma: any = prisma as any;

describe("idempotencyMiddleware", () => {
  beforeEach(() => {
    mockPrisma.idempotency_keys.findFirst.mockReset();
    mockPrisma.idempotency_keys.create.mockReset();
    mockPrisma.idempotency_keys.update.mockReset();
  });

  test("skips when no Idempotency-Key header", async () => {
    const req: any = { method: "POST", header: jest.fn().mockReturnValue(null), body: {} };
    const res: any = {};
    const next = jest.fn();
    await idempotencyMiddleware(req, res, next);
    expect(next).toHaveBeenCalled();
  });

  test("returns 409 when processing", async () => {
    mockPrisma.idempotency_keys.findFirst.mockResolvedValue({ processing: true });
    const req: any = { method: "POST", header: jest.fn().mockReturnValue("key1"), body: {}, path: "/api/me/workouts", user: { user_id: 1 } };
    const res: any = { status: jest.fn().mockReturnThis(), json: jest.fn() };
    const next = jest.fn();
    await idempotencyMiddleware(req, res, next);
    expect(res.status).toHaveBeenCalledWith(409);
    expect(res.json).toHaveBeenCalledWith({ message: "Request with this Idempotency-Key is currently being processed" });
    expect(next).not.toHaveBeenCalled();
  });

  test("returns stored response when present", async () => {
    mockPrisma.idempotency_keys.findFirst.mockResolvedValue({ processing: false, response_body: { ok: true }, response_status: 201, response_headers: { "x-test": "1" } });
    const req: any = { method: "POST", header: jest.fn().mockReturnValue("k2"), body: {}, path: "/api/me/workouts", user: { user_id: 1 } };
    const res: any = { status: jest.fn().mockReturnThis(), json: jest.fn(), setHeader: jest.fn() };
    const next = jest.fn();
    await idempotencyMiddleware(req, res, next);
    expect(res.setHeader).toHaveBeenCalledWith("x-test", "1");
    expect(res.status).toHaveBeenCalledWith(201);
    expect(res.json).toHaveBeenCalledWith({ ok: true });
    expect(next).not.toHaveBeenCalled();
  });

  test("creates record and captures response", async () => {
    mockPrisma.idempotency_keys.findFirst.mockResolvedValue(null);
    mockPrisma.idempotency_keys.create.mockResolvedValue({ id: 10 });

    const req: any = { method: "POST", header: jest.fn().mockReturnValue("k3"), body: { foo: "bar" }, path: "/api/me/workouts", user: { user_id: 1 } };
    const res: any = { statusCode: 200 };
    res.status = jest.fn().mockImplementation((s: number) => {
      res.statusCode = s;
      return res;
    });
    res.json = jest.fn().mockImplementation((b: any) => {
      res._body = b;
      return res;
    });
    res.send = jest.fn().mockImplementation((b: any) => {
      res._body = b;
      return res;
    });
    res.getHeaders = jest.fn().mockReturnValue({ "content-type": "application/json" });
    res.setHeader = jest.fn();

    const next = jest.fn();

    await idempotencyMiddleware(req, res, next);
    expect(next).toHaveBeenCalled();

    // simulate handler writing response
    res.json({ created: true });

    // allow async update to run
    await new Promise((r) => setImmediate(r));

    expect(mockPrisma.idempotency_keys.update).toHaveBeenCalledWith({
      where: { id: 10 },
      data: expect.objectContaining({ response_body: { created: true }, response_status: 200 }),
    });
  });
});
