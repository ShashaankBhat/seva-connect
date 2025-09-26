// lib/prisma.ts
import { PrismaClient } from "@prisma/client";

declare global {
    // Prevent multiple instances of Prisma Client in development
    // This ensures hot-reloading won't create multiple clients
    var prisma: PrismaClient | undefined;
}

export const prisma =
    global.prisma ||
    new PrismaClient({
        log: ["query"], // Optional: logs all queries, helpful in dev
    });

if (process.env.NODE_ENV !== "production") global.prisma = prisma;
