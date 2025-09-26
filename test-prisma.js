import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
    // Example: Create a donor
    const donor = await prisma.donor.create({
        data: {
            donor_name: "John Doe",
            donor_email: "john@example.com",
            donor_password: "password123",
        },
    });

    console.log("New donor created:", donor);

    // Example: Fetch all donors
    const donors = await prisma.donor.findMany();
    console.log("All donors:", donors);
}

main()
    .catch((e) => console.error(e))
    .finally(async () => {
        await prisma.$disconnect();
    });
