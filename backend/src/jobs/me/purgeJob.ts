import cron from "node-cron";
import * as meService from "../../services/me/me.service";

// Run daily at 02:00 AM
export const startPurgeJob = (graceDays = 30) => {
  cron.schedule("0 2 * * *", async () => {
    try {
      const res = await meService.purgeDeletedUsers(graceDays);
      console.log(`[purgeJob] purged ${res.deleted} users older than ${graceDays} days`);
    } catch (err) {
      console.error("[purgeJob] error purging users", err);
    }
  });
};

export const runPurgeNow = async (graceDays = 30) => {
  return meService.purgeDeletedUsers(graceDays);
};
