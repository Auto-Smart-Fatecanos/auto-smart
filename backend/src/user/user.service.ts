import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { User } from '@prisma/client';
import { validateCPF } from 'src/common/helpers/cpf-validator';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  // implementar validação de senha forte
  async create(
    userData: Omit<User, 'id' | 'refreshToken' | 'levelAcesso'>,
  ): Promise<Partial<User>> {
    const tempUser = await this.prisma.user.findFirst({
      where: {
        OR: [{ email: userData.email }, { cpf: userData.cpf }],
      },
    });

    if (tempUser) {
      throw new BadRequestException({ message: 'Email ou CPF já cadastrado' });
    }

    if (userData.cpf && !validateCPF(userData.cpf)) {
      throw new BadRequestException({ message: 'CPF inválido' });
    }
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    const userCpf: string = userData.cpf.replace(/\D/g, '');

    try {
      const user: Partial<User> = await this.prisma.user.create({
        data: {
          ...userData,
          password: hashedPassword,
          cpf: userCpf,
          levelAcesso: 'USER',
        },
      });

      delete user.password;
      delete user.refreshToken;
      delete user.levelAcesso;

      return user;
    } catch (error: unknown) {
      throw new BadRequestException({
        message: 'Error ao criar usuário',
        error,
      });
    }
  }

  async findByCpf(cpf: string) {
    return this.prisma.user.findUnique({
      where: { cpf: cpf },
      include: { store: true },
    });
  }

  async findById(id: number) {
    return this.prisma.user.findUnique({
      where: { id },
      include: { store: true },
    });
  }

  async updateUser(
    id: number,
    userData: Partial<Omit<User, 'id' | 'refreshToken'>>,
  ): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) {
      throw new BadRequestException({ message: 'Usuário não encontrado' });
    }

    if (userData.password)
      userData.password = await bcrypt.hash(userData.password, 10);

    try {
      await this.prisma.user.update({
        where: { id },
        data: userData,
      });
    } catch (error: unknown) {
      throw new BadRequestException({
        message: 'Error ao atualizar usuário',
        error,
      });
    }
  }

  async updateRefreshToken(cpf: string, refreshToken: string | null) {
    const hashedRefreshToken: string | null = refreshToken
      ? await bcrypt.hash(refreshToken, 10)
      : null;

    return this.prisma.user.update({
      where: { cpf },
      data: { refreshToken: hashedRefreshToken },
    });
  }
}
