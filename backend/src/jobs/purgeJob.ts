import cron from "node-cron";
import * as meService from "../services/me.service";

// Run daily at 02:00 AM
export const startPurgeJob = (graceDays = 30) => {
  cron.schedule("0 2 * * *", async () => {
    try {
      const res = await meService.purgeDeletedUsers(graceDays);
      // optionally log result
      console.log(`[purgeJob] purged ${res.deleted} users older than ${graceDays} days`);
    } catch (err) {
      console.error("[purgeJob] error purging users", err);
    }
  });
};

// Also export a function to run once immediately (useful for manual invocation)
export const runPurgeNow = async (graceDays = 30) => {
  return meService.purgeDeletedUsers(graceDays);
};
