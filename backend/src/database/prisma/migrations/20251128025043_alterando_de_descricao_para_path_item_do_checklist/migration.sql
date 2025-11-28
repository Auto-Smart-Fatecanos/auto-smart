/*
  Warnings:

  - You are about to drop the column `descricao` on the `ChekListPhotos` table. All the data in the column will be lost.
  - Added the required column `path` to the `ChekListPhotos` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "ChekListPhotos" DROP COLUMN "descricao",
ADD COLUMN     "path" TEXT NOT NULL;
