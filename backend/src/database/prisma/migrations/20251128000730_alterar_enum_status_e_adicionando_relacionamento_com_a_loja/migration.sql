/*
  Warnings:

  - The values [AGUARDANDO,REJEITADO,CANCELADO] on the enum `Status` will be removed. If these variants are still used in the database, this will fail.
  - Added the required column `storeId` to the `Orcamento` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Status_new" AS ENUM ('PENDENTE', 'EM_MANUTENCAO', 'SERVICO_EXTERNO', 'REPROVADO', 'FINALIZADO');
ALTER TABLE "public"."Orcamento" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Orcamento" ALTER COLUMN "status" TYPE "Status_new" USING ("status"::text::"Status_new");
ALTER TYPE "Status" RENAME TO "Status_old";
ALTER TYPE "Status_new" RENAME TO "Status";
DROP TYPE "public"."Status_old";
ALTER TABLE "Orcamento" ALTER COLUMN "status" SET DEFAULT 'PENDENTE';
COMMIT;

-- AlterTable
ALTER TABLE "Orcamento" ADD COLUMN     "storeId" INTEGER NOT NULL,
ALTER COLUMN "status" SET DEFAULT 'PENDENTE';

-- AddForeignKey
ALTER TABLE "Orcamento" ADD CONSTRAINT "Orcamento_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "Store"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
