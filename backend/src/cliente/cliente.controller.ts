import {
  Controller,
  Get,
  Post,
  Put,
  Param,
  Body,
  UseGuards,
  BadRequestException,
  NotFoundException,
  ParseIntPipe,
} from '@nestjs/common';

import { ClienteService } from './cliente.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Cliente } from '@prisma/client';

import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiBody,
} from '@nestjs/swagger';

import { CreateClienteDto } from './cliente.dto';
import { UpdateClienteDto } from './cliente.update.dto';
import { validateCPF } from 'src/common/helpers/cpf-validator';

@ApiTags('Clientes')
@UseGuards(JwtAuthGuard)
@Controller('clientes')
export class ClienteController {
  constructor(private readonly clienteService: ClienteService) {}

  @Post()
  @ApiOperation({ summary: 'Cria um novo cliente' })
  @ApiResponse({ status: 201, description: 'Cliente criado com sucesso' })
  @ApiResponse({
    status: 400,
    description: 'CPF inválido ou cliente já existe',
  })
  @ApiBody({ type: CreateClienteDto })
  async create(@Body() data: CreateClienteDto): Promise<Cliente> {
    const result = await this.clienteService.create(data);

    if (result.message) {
      throw new BadRequestException(result.message);
    }

    return result.data as Cliente;
  }

  // Busca um cliente por CPF antes do orçamento !!
  @Get(':cpf')

  @ApiOperation({ summary: 'Busca um cliente pelo CPF' })
  @ApiResponse({ status: 200, description: 'Cliente encontrado' })
  @ApiResponse({ status: 404, description: 'Cliente não encontrado' })
  @ApiParam({ name: 'cpf', example: '12345678900' })
  async findOne(@Param('cpf') cpf: string): Promise<Cliente> {
    const sanitizedCpf = cpf.replace(/\D/g, '');


    if (!validateCPF(sanitizedCpf)) {
      throw new BadRequestException('CPF inválido');
    }

    const cliente = await this.clienteService.findOne(sanitizedCpf);

    if (!cliente) {
      throw new NotFoundException(
        `Cliente com CPF ${sanitizedCpf} não encontrado`,
      );
    }

    return cliente;
  }
  @Put(':id')
  @ApiOperation({ summary: 'Atualiza um cliente' })
  @ApiResponse({ status: 200, description: 'Cliente atualizado com sucesso' })
  @ApiParam({ name: 'id', example: 1 })
  @ApiBody({ type: UpdateClienteDto })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() data: UpdateClienteDto,
  ): Promise<Cliente> {
    return this.clienteService.update(id, data);
  }
}
