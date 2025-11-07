import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import type { Cliente } from '@prisma/client';

@Injectable()
export class ClienteService {
  constructor(private prisma: PrismaService) {}

  async create(data: {
    nome: string;
    cpf: string;
    telefone: string;
  }): Promise<Cliente> {
    return this.prisma.cliente.create({ data });
  }

  async findAll(): Promise<Cliente[]> {
    return this.prisma.cliente.findMany();
  }

  async findOne(id: number): Promise<Cliente | null> {
    return this.prisma.cliente.findUnique({ where: { id } });
  }

  async update(
    id: number,
    data: { nome?: string; cpf?: string; telefone?: string },
  ): Promise<Cliente> {
    return this.prisma.cliente.update({
      where: { id },
      data,
    });
  }

  async remove(id: number): Promise<Cliente> {
    return this.prisma.cliente.delete({ where: { id } });
  }
}
