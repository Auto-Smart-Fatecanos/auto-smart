import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  BadRequestException,
  Query,
  UseGuards,
  Patch,
  Delete,
  NotFoundException,
} from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import { Status, Orcamento, OrcamentoItem } from '@prisma/client';
import { CreateOrcamentoDto, UpdateOrcamentoItensDto } from './orcamento.dto';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { UserService } from 'src/user/user.service';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiQuery,
  ApiParam,
  ApiBearerAuth,
} from '@nestjs/swagger';

@ApiBearerAuth()
@ApiTags('Orçamentos')
@UseGuards(JwtAuthGuard)
@Controller('orcamentos')
export class OrcamentoController {
  constructor(
    private readonly orcamentoService: OrcamentoService,
    private readonly userService: UserService,
  ) {}

  @Post()
  @ApiOperation({
    summary: 'Cria um novo orçamento',
    description: 'Cria um orçamento com seus itens relacionados.',
  })
  @ApiResponse({ status: 201, description: 'Orçamento criado com sucesso' })
  @ApiResponse({ status: 400, description: 'Erro de validação' })
  async create(
    @Body() body: CreateOrcamentoDto,
  ): Promise<Orcamento & { orcamentoItems: OrcamentoItem[] }> {
    const { Orcamento, orcamentoItens } = body;

    return this.orcamentoService.create({
      orcamento: Orcamento,
      orcamentoItens: orcamentoItens.orcamentoItens,
    });
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Busca um orçamento pelo ID',
  })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiResponse({ status: 200, description: 'Orçamento retornado com sucesso' })
  @ApiResponse({ status: 404, description: 'Orçamento não encontrado' })
  async findOne(@Param('id') id: number): Promise<Orcamento | null> {
    return this.orcamentoService.findOne(Number(id));
  }

  @Get()
  @ApiOperation({
    summary: 'Lista todos os orçamentos com paginação',
  })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'limit', required: false, example: 10 })
  @ApiResponse({
    status: 200,
    description: 'Lista de orçamentos retornada com sucesso',
  })
  async findAll(
    @Query('page') page = 1,
    @Query('limit') limit = 10,
  ): Promise<{
    data: Orcamento[];
    total: number;
    page: number;
    limit: number;
  }> {
    return this.orcamentoService.findAll(Number(page), Number(limit));
  }

  @Patch(':id/status')
  @ApiOperation({
    summary: 'Atualiza o status de um orçamento',
  })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiResponse({ status: 200, description: 'Status atualizado com sucesso' })
  @ApiResponse({ status: 400, description: 'Status inválido' })
  @ApiResponse({ status: 404, description: 'Orçamento não encontrado' })
  async updateStatus(@Param('id') id: number, @Body('status') status: Status) {
    if (status === undefined)
      throw new BadRequestException('status é obrigatório');

    try {
      return await this.orcamentoService.updateStatus(Number(id), status);
    } catch (error: unknown) {
      throw new NotFoundException(
        (error as Error).message || 'Erro ao atualizar status',
      );
    }
  }

  @Patch(':id/itens')
  @ApiOperation({
    summary: 'Atualiza os itens de um orçamento',
  })
  @ApiParam({ name: 'id', type: Number, example: 5 })
  @ApiResponse({
    status: 200,
    description: 'Itens atualizados com sucesso',
  })
  @ApiResponse({
    status: 400,
    description: 'Erro ao atualizar itens ou dados inválidos',
  })
  async updateItens(
    @Param('id') id: number,
    @Body() body: UpdateOrcamentoItensDto,
  ): Promise<OrcamentoItem[]> {
    if (!id) throw new BadRequestException('ID do orçamento é obrigatório');

    try {
      return await this.orcamentoService.updateItens(Number(id), body.itens);
    } catch (error: unknown) {
      throw new BadRequestException(
        (error as Error).message || 'Erro ao atualizar itens',
      );
    }
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'Exclui um orçamento',
  })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiResponse({ status: 200, description: 'Orçamento excluído com sucesso' })
  @ApiResponse({ status: 404, description: 'Orçamento não encontrado' })
  async remove(@Param('id') id: number): Promise<Orcamento> {
    try {
      return await this.orcamentoService.remove(Number(id));
    } catch (error: unknown) {
      throw new NotFoundException(
        (error as Error).message || 'Erro ao excluir orçamento',
      );
    }
  }
}
