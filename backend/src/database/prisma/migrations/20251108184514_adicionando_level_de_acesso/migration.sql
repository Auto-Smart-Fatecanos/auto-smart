-- CreateEnum
CREATE TYPE "LevelAcesso" AS ENUM ('ADMIN', 'USER');

-- AlterTable
ALTER TABLE "Orcamento" ALTER COLUMN "status" SET DEFAULT 'AGUARDANDO';

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "levelAcesso" "LevelAcesso" DEFAULT 'USER';
