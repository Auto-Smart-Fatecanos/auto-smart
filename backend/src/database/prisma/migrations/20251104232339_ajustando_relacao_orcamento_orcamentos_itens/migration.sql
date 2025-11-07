/*
  Warnings:

  - You are about to drop the column `orcamentoItemId` on the `Orcamento` table. All the data in the column will be lost.
  - Added the required column `orcamentoId` to the `OrcamentoItem` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "public"."Orcamento" DROP CONSTRAINT "Orcamento_orcamentoItemId_fkey";

-- AlterTable
ALTER TABLE "Orcamento" DROP COLUMN "orcamentoItemId";

-- AlterTable
ALTER TABLE "OrcamentoItem" ADD COLUMN     "orcamentoId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "OrcamentoItem" ADD CONSTRAINT "OrcamentoItem_orcamentoId_fkey" FOREIGN KEY ("orcamentoId") REFERENCES "Orcamento"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
