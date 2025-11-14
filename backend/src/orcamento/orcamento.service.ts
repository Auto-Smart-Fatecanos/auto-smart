import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { Status, type Orcamento, type OrcamentoItem } from '@prisma/client';

@Injectable()
export class OrcamentoService {
  constructor(private prisma: PrismaService) {}

  async create(data: {
    orcamento: Omit<Orcamento, 'id' | 'dataCriacao' | 'status'>;
    orcamentoItens: Omit<OrcamentoItem, 'id' | 'orcamentoId' | 'ativo'>[];
  }): Promise<Orcamento & { orcamentoItems: OrcamentoItem[] }> {
    const created = await this.prisma.$transaction(async (tx) => {
      const orcamento = await tx.orcamento.create({
        data: data.orcamento,
      });

      if (data.orcamentoItens?.length) {
        const itens = data.orcamentoItens.map((item) => ({
          ...item,
          orcamentoId: orcamento.id,
        }));
        await tx.orcamentoItem.createMany({ data: itens });
      }

      return orcamento;
    });

    return this.prisma.orcamento.findUniqueOrThrow({
      where: { id: created.id },
      include: { orcamentoItems: true, cliente: true },
    });
  }

  //implementar para trazer apenas o da loja atual
  async findAll(
    page: number,
    limit: number,
  ): Promise<{
    data: Orcamento[];
    total: number;
    page: number;
    limit: number;
  }> {
    const skip = (page - 1) * limit;

    const [data, total] = await this.prisma.$transaction([
      this.prisma.orcamento.findMany({
        skip,
        take: limit,
        orderBy: { id: 'desc' },
        include: { orcamentoItems: true },
      }),
      this.prisma.orcamento.count(),
    ]);

    return { data, total, page, limit };
  }

  async findOne(id: number): Promise<Orcamento | null> {
    return this.prisma.orcamento.findUnique({
      where: { id },
      include: { cliente: true, orcamentoItems: true },
    });
  }

  async remove(id: number): Promise<Orcamento> {
    return this.prisma.orcamento.delete({ where: { id } });
  }

  async updateStatus(id: number, status: Status): Promise<Orcamento> {
    const orcamento = await this.findOne(id);

    if (!orcamento) {
      throw new Error('Orçamento não encontrado');
    }

    console.log(status);
    return this.prisma.orcamento.update({
      where: { id },
      data: { status },
    });
  }

  async getItens(idOrcamento: number): Promise<OrcamentoItem[]> {
    return this.prisma.orcamentoItem.findMany({
      where: { orcamentoId: idOrcamento },
    });
  }

  async updateItens(
    id: number,
    itens: OrcamentoItem[],
  ): Promise<OrcamentoItem[]> {
    const orcamento = await this.findOne(id);

    if (!orcamento) {
      throw new Error('Orçamento não encontrado');
    }

    const orcamentosItems = await this.getItens(id);

    if (!orcamentosItems) {
      throw new Error('Itens do orçamento não encontrados');
    }

    if (orcamentosItems.length < itens.length) {
      throw new Error(
        'A quantidade de itens enviado excede a salva do orçamento',
      );
    }

    //remover
    console.log({ itens, orcamentosItems });

    try {
      const updated = await Promise.all(
        itens.map((item) =>
          this.prisma.orcamentoItem.update({
            where: { id: item.id },
            data: {
              descricao: item.descricao,
              tipoOrcamento: item.tipoOrcamento,
              orcamentoValor: item.orcamentoValor,
              ativo: item.ativo,
            },
          }),
        ),
      );

      return updated;
    } catch (error: unknown) {
      throw new Error(error as string);
    }
  }
}
