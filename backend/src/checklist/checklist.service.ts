import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma/prisma.service';
import { CreateChecklistDto } from './dto/create-checklist.dto';
import { Checklist } from '@prisma/client';

@Injectable()
export class ChecklistService {
  constructor(private prisma: PrismaService) {}

  async createChecklist(
    data: CreateChecklistDto,
    files: Express.Multer.File[],
    cpf: string,
  ): Promise<Checklist> {
    try {
      const user = await this.prisma.user.findUnique({
        where: { cpf: cpf },
      });

      const orcamento = await this.prisma.orcamento.findUnique({
        where: { id: data.orcamentoId },
      });

      if (!user) {
        throw new BadRequestException('Usuário não encontrado');
      }
      if (!orcamento) {
        throw new BadRequestException('Orçamento não encontrado');
      }

      const checkList: Checklist[] = await this.prisma.checklist.findMany({
        where: {
          orcamentoId: orcamento.id,
        },
      });

      if (checkList.length === 2) {
        throw new BadRequestException(
          'Limite de checklists atingido para este orçamento',
        );
      }

      if (checkList.length === 1 && data.tipo === 'CHECK_IN') {
        throw new BadRequestException(
          'Check-in já cadastrado para este orçamento',
        );
      }

      if (checkList.length === 0 && data.tipo === 'CHECK_OUT') {
        throw new BadRequestException(
          'Check-in ainda não foi cadastrado para este orçamento',
        );
      }

      const hasSameType = checkList.some((cl) => cl.tipo === data.tipo);
      if (hasSameType) {
        throw new BadRequestException(
          `Já existe um checklist do tipo ${data.tipo} para este orçamento`,
        );
      }
      const item = {
        storeId: user.storeId,
        userId: user.id,
        ...data,
      };

      const result: Checklist = await this.prisma.checklist.create({
        data: item,
      });

      return result;
    } catch (error) {
      throw new BadRequestException(
        error instanceof Error ? error.message : 'Erro inesperado',
      );
    }
  }
}
