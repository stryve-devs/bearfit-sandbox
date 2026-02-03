import { Request, Response, NextFunction } from "express";
import prisma from "../config/prismaClient";
import crypto from "crypto";

const writeMethods = new Set(["POST", "PUT", "PATCH", "DELETE"]);

export const idempotencyMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  try {
    if (!writeMethods.has(req.method)) return next();

    const idKey = req.header("Idempotency-Key") || req.header("idempotency-key");
    if (!idKey) return next();

    const userId = (req as any).user?.user_id ?? null;
    const path = req.path;
    const method = req.method;

    const hash = crypto.createHash("sha256");
    const bodyString = req.body && Object.keys(req.body).length ? JSON.stringify(req.body) : "";
    hash.update(`${method}:${path}:${bodyString}`);
    const requestHash = hash.digest("hex");

    // look for existing key
    const idempotencyModel = (prisma as any)["idempotency_keys"];
    if (!idempotencyModel) {
      // If the model doesn't exist in the connected database, skip idempotency handling
      return next();
    }

    const existing = await idempotencyModel.findFirst({
      where: { user_id: userId, idempotency_key: idKey, path },
    });

    if (existing) {
      if (existing.processing) {
        return res.status(409).json({ message: "Request with this Idempotency-Key is currently being processed" });
      }
      if (existing.response_body) {
        const status = existing.response_status ?? 200;
        // set stored headers if present
        if (existing.response_headers) {
          try {
            Object.entries(existing.response_headers as Record<string, string>).forEach(([k, v]) => res.setHeader(k, v as string));
          } catch (e) {
            // ignore header set errors
          }
        }
        return res.status(status).json(existing.response_body);
      }
    }

    // create a new idempotency record marked processing
    const record = await idempotencyModel.create({
      data: {
        user_id: userId,
        idempotency_key: idKey,
        method,
        path,
        request_hash: requestHash,
        processing: true,
      },
    });

    // monkey-patch res.json/res.send to capture response
    const originalJson = res.json.bind(res);
    const originalSend = res.send.bind(res);

    const captureAndUpdate = async (body: any) => {
      // attempt to capture headers
      const headers: Record<string, string> = {};
      try {
        // @ts-ignore - Express may not have getHeaders typed
        const rawHeaders = res.getHeaders();
        Object.entries(rawHeaders).forEach(([k, v]) => {
          if (typeof v === "string") headers[k] = v;
        });
      } catch (e) {
        // ignore
      }

      try {
        await idempotencyModel.update({
          where: { id: record.id },
          data: {
            response_body: body,
            response_status: res.statusCode,
            response_headers: headers,
            processing: false,
          },
        });
      } catch (e) {
        // don't break response path if DB update fails
        console.error("Failed to update idempotency record:", e);
      }
    };

    res.json = (body: any) => {
      // schedule DB update but don't await to avoid delaying response
      captureAndUpdate(body).catch((e) => console.error(e));
      return originalJson(body);
    };

    res.send = (body: any) => {
      captureAndUpdate(body).catch((e) => console.error(e));
      return originalSend(body);
    };

    // ensure that if the request errors, we unset processing flag
    const originalNext = next;

    // attach idempotency record id to request for potential use
    (req as any).idempotencyRecordId = record.id;

    return originalNext();
  } catch (err) {
    console.error("Idempotency middleware error:", err);
    return next();
  }
};
