/*
  Warnings:

  - Made the column `userId` on table `Checklist` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "public"."Checklist" DROP CONSTRAINT "Checklist_userId_fkey";

-- AlterTable
ALTER TABLE "Checklist" ALTER COLUMN "userId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Checklist" ADD CONSTRAINT "Checklist_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
