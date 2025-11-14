import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import type { Cliente } from '@prisma/client';
import { validateCPF } from 'src/common/helpers/cpf-validator';

@Injectable()
export class ClienteService {
  constructor(private prisma: PrismaService) {}

  async create(data: {
    nome: string;
    cpf: string;
    telefone: string;
  }): Promise<{ data: Cliente | null; message: string }> {
    const cpf = data.cpf.replace(/\D/g, '');

    if (!validateCPF(cpf)) {
      return { data: null, message: 'CPF inválido' };
    }

    const existingCliente = await this.prisma.cliente.findUnique({
      where: { cpf },
    });

    if (existingCliente) {
      return { data: null, message: 'Cliente com este CPF já existe' };
    }

    const newCliente = await this.prisma.cliente.create({
      data: {
        nome: data.nome,
        cpf: cpf,
        telefone: data.telefone,
      },
    });
    return {
      data: newCliente,
      message: '',
    };
  }

  // Busca um cliente por CPF antes do orçamento !!
  async findOne(cpf: string): Promise<Cliente | null> {
    return this.prisma.cliente.findUnique({
      where: { cpf },
    });
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
}
