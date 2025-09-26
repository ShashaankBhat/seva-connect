-- CreateEnum
CREATE TYPE "public"."AdminRole" AS ENUM ('superadmin', 'moderator');

-- CreateEnum
CREATE TYPE "public"."AdminStatus" AS ENUM ('active', 'inactive');

-- CreateEnum
CREATE TYPE "public"."NGOStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "public"."CampaignStatus" AS ENUM ('upcoming', 'ongoing', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "public"."Urgency" AS ENUM ('low', 'medium', 'high');

-- CreateEnum
CREATE TYPE "public"."RequirementStatus" AS ENUM ('open', 'fulfilled', 'expired');

-- CreateEnum
CREATE TYPE "public"."PickupOrDrop" AS ENUM ('pickup', 'drop');

-- CreateEnum
CREATE TYPE "public"."DonationStatus" AS ENUM ('pending', 'received', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "public"."Category" AS ENUM ('food', 'clothing', 'medical', 'educational', 'hygiene', 'electronics', 'furniture', 'other');

-- CreateEnum
CREATE TYPE "public"."InventoryStatus" AS ENUM ('in_stock', 'low_stock', 'out_of_stock', 'expired');

-- CreateEnum
CREATE TYPE "public"."RequestStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateTable
CREATE TABLE "public"."Admin" (
    "admin_id" SERIAL NOT NULL,
    "admin_name" TEXT NOT NULL,
    "admin_email" TEXT NOT NULL,
    "admin_password" TEXT NOT NULL,
    "admin_role" "public"."AdminRole" NOT NULL DEFAULT 'superadmin',
    "admin_status" "public"."AdminStatus" NOT NULL DEFAULT 'active',

    CONSTRAINT "Admin_pkey" PRIMARY KEY ("admin_id")
);

-- CreateTable
CREATE TABLE "public"."Donor" (
    "donor_id" SERIAL NOT NULL,
    "donor_name" TEXT NOT NULL,
    "donor_email" TEXT NOT NULL,
    "donor_password" TEXT NOT NULL,
    "donor_preferences" TEXT,
    "donor_contact" TEXT,
    "donor_address" TEXT,
    "donor_city" TEXT,
    "donor_state" TEXT,

    CONSTRAINT "Donor_pkey" PRIMARY KEY ("donor_id")
);

-- CreateTable
CREATE TABLE "public"."NGO" (
    "ngo_id" SERIAL NOT NULL,
    "ngo_name" TEXT NOT NULL,
    "ngo_email" TEXT NOT NULL,
    "ngo_password" TEXT NOT NULL,
    "ngo_registration_no" TEXT,
    "ngo_status" "public"."NGOStatus" NOT NULL DEFAULT 'pending',
    "ngo_contact" TEXT,

    CONSTRAINT "NGO_pkey" PRIMARY KEY ("ngo_id")
);

-- CreateTable
CREATE TABLE "public"."Campaign" (
    "campaign_id" SERIAL NOT NULL,
    "ngo_id" INTEGER NOT NULL,
    "campaign_title" TEXT NOT NULL,
    "campaign_description" TEXT,
    "campaign_date" TIMESTAMP(3) NOT NULL,
    "campaign_location" TEXT NOT NULL,
    "campaign_requirements" TEXT,
    "status" "public"."CampaignStatus" NOT NULL DEFAULT 'upcoming',
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Campaign_pkey" PRIMARY KEY ("campaign_id")
);

-- CreateTable
CREATE TABLE "public"."Requirement" (
    "requirement_id" SERIAL NOT NULL,
    "ngo_id" INTEGER NOT NULL,
    "item_name" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "urgency" "public"."Urgency" NOT NULL DEFAULT 'medium',
    "expiry_date" TIMESTAMP(3),
    "status" "public"."RequirementStatus" NOT NULL DEFAULT 'open',

    CONSTRAINT "Requirement_pkey" PRIMARY KEY ("requirement_id")
);

-- CreateTable
CREATE TABLE "public"."Donation" (
    "donation_id" SERIAL NOT NULL,
    "requirement_id" INTEGER,
    "donated_item" TEXT NOT NULL,
    "donated_quantity" INTEGER NOT NULL,
    "pickup_or_drop" "public"."PickupOrDrop" NOT NULL,
    "donation_status" "public"."DonationStatus" NOT NULL DEFAULT 'pending',
    "donor_id" INTEGER,
    "ngo_id" INTEGER,

    CONSTRAINT "Donation_pkey" PRIMARY KEY ("donation_id")
);

-- CreateTable
CREATE TABLE "public"."InventoryItem" (
    "inventory_id" SERIAL NOT NULL,
    "ngo_id" INTEGER NOT NULL,
    "item_name" TEXT NOT NULL,
    "category" "public"."Category" NOT NULL DEFAULT 'other',
    "current_quantity" INTEGER NOT NULL DEFAULT 0,
    "minimum_stock" INTEGER NOT NULL DEFAULT 10,
    "unit" TEXT NOT NULL DEFAULT 'units',
    "expiry_date" TIMESTAMP(3),
    "storage_location" TEXT,
    "notes" TEXT,
    "status" "public"."InventoryStatus" NOT NULL DEFAULT 'in_stock',
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InventoryItem_pkey" PRIMARY KEY ("inventory_id")
);

-- CreateTable
CREATE TABLE "public"."Newsletter" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "subscribed_at" TIMESTAMP(3),
    "unsubscribed_at" TIMESTAMP(3),

    CONSTRAINT "Newsletter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Request" (
    "request_id" SERIAL NOT NULL,
    "donor_id" INTEGER,
    "ngo_id" INTEGER,
    "item_name" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "status" "public"."RequestStatus" NOT NULL DEFAULT 'pending',

    CONSTRAINT "Request_pkey" PRIMARY KEY ("request_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Admin_admin_email_key" ON "public"."Admin"("admin_email");

-- CreateIndex
CREATE UNIQUE INDEX "Donor_donor_email_key" ON "public"."Donor"("donor_email");

-- CreateIndex
CREATE UNIQUE INDEX "NGO_ngo_email_key" ON "public"."NGO"("ngo_email");

-- CreateIndex
CREATE UNIQUE INDEX "NGO_ngo_registration_no_key" ON "public"."NGO"("ngo_registration_no");

-- CreateIndex
CREATE UNIQUE INDEX "Newsletter_email_key" ON "public"."Newsletter"("email");

-- AddForeignKey
ALTER TABLE "public"."Campaign" ADD CONSTRAINT "Campaign_ngo_id_fkey" FOREIGN KEY ("ngo_id") REFERENCES "public"."NGO"("ngo_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Requirement" ADD CONSTRAINT "Requirement_ngo_id_fkey" FOREIGN KEY ("ngo_id") REFERENCES "public"."NGO"("ngo_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Donation" ADD CONSTRAINT "Donation_donor_id_fkey" FOREIGN KEY ("donor_id") REFERENCES "public"."Donor"("donor_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Donation" ADD CONSTRAINT "Donation_ngo_id_fkey" FOREIGN KEY ("ngo_id") REFERENCES "public"."NGO"("ngo_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Donation" ADD CONSTRAINT "Donation_requirement_id_fkey" FOREIGN KEY ("requirement_id") REFERENCES "public"."Requirement"("requirement_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_ngo_id_fkey" FOREIGN KEY ("ngo_id") REFERENCES "public"."NGO"("ngo_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Request" ADD CONSTRAINT "Request_donor_id_fkey" FOREIGN KEY ("donor_id") REFERENCES "public"."Donor"("donor_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Request" ADD CONSTRAINT "Request_ngo_id_fkey" FOREIGN KEY ("ngo_id") REFERENCES "public"."NGO"("ngo_id") ON DELETE SET NULL ON UPDATE CASCADE;
