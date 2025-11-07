import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ClienteService } from './cliente.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Cliente } from '@prisma/client';

@UseGuards(JwtAuthGuard) // protege todos os endpoints
@Controller('clientes')
export class ClienteController {
  constructor(private readonly clienteService: ClienteService) {}

  @Post()
  async create(
    @Body() data: { nome: string; cpf: string; telefone: string },
  ): Promise<Cliente> {
    return this.clienteService.create(data);
  }

  @Get()
  async findAll(): Promise<Cliente[]> {
    return this.clienteService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Cliente | null> {
    return this.clienteService.findOne(Number(id));
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() data: Partial<{ nome: string; cpf: string; telefone: string }>,
  ): Promise<Cliente> {
    return this.clienteService.update(Number(id), data);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Cliente> {
    return this.clienteService.remove(Number(id));
  }
}
