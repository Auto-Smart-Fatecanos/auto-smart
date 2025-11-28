/*
  Warnings:

  - Added the required column `criadoPor` to the `Orcamento` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Orcamento" ADD COLUMN     "criadoPor" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "Orcamento" ADD CONSTRAINT "Orcamento_criadoPor_fkey" FOREIGN KEY ("criadoPor") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
