// pages/api/donors/index.ts
import type { NextApiRequest, NextApiResponse } from "next";
import { prisma } from "@/lib/prisma"; // Updated import
import bcrypt from "bcrypt";

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse
) {
    if (req.method === "POST") {
        try {
            const { donor_name, donor_email, donor_password } = req.body;

            if (!donor_name || !donor_email || !donor_password) {
                return res.status(400).json({ error: "Missing fields" });
            }

            // Hash password before saving
            const hashedPassword = await bcrypt.hash(donor_password, 10);

            const donor = await prisma.donor.create({
                data: {
                    donor_name,
                    donor_email,
                    donor_password: hashedPassword,
                },
            });

            return res.status(201).json(donor);
        } catch (error) {
            console.error("Error creating donor:", error);
            return res.status(500).json({ error: "Something went wrong" });
        }
    }

    if (req.method === "GET") {
        try {
            const donors = await prisma.donor.findMany();
            return res.status(200).json(donors);
        } catch (error) {
            console.error("Error fetching donors:", error);
            return res.status(500).json({ error: "Something went wrong" });
        }
    }

    res.setHeader("Allow", ["GET", "POST"]);
    return res.status(405).end(`Method ${req.method} Not Allowed`);
}
