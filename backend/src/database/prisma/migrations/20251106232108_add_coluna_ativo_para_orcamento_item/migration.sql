/*
  Warnings:

  - Added the required column `descricao` to the `OrcamentoItem` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "OrcamentoItem" ADD COLUMN     "ativo" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "descricao" TEXT NOT NULL;
