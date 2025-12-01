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
  Req,
  UnauthorizedException,
  UseInterceptors,
  UploadedFile,
  Res,
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
import type { Request, Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import { multerConfig } from 'src/upload/multer.config';
import { join } from 'path';
import { promises as fs } from 'fs';

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
    @Req() req: Request,
  ): Promise<Orcamento & { orcamentoItems: OrcamentoItem[] }> {
    const { Orcamento, orcamentoItens } = body;

    const { cpf } = req.user as { cpf: string };

    if (!cpf) throw new UnauthorizedException('Usuário não autenticado');

    return this.orcamentoService.create(
      {
        orcamento: Orcamento,
        orcamentoItens: orcamentoItens.orcamentoItens,
      },
      cpf,
    );
  }

  @Get()
  @ApiOperation({
    summary: 'Lista todos os orçamentos com paginação',
  })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'limit', required: false, example: 10 })
  @ApiQuery({ name: 'status', required: false, enum: Status, description: 'Filtrar por status' })
  @ApiResponse({
    status: 200,
    description: 'Lista de orçamentos retornada com sucesso',
  })
  async findAll(
    @Query('page') page = 1,
    @Query('limit') limit = 10,
    @Query('status') status?: Status,
  ): Promise<{
    data: Orcamento[];
    total: number;
    page: number;
    limit: number;
  }> {
    if (status) {
      return this.orcamentoService.findByStatus(status, Number(page), Number(limit));
    }
    return this.orcamentoService.findAll(Number(page), Number(limit));
  }

  @Get('ganhos')
  @ApiOperation({
    summary: 'Retorna os ganhos totais dos orçamentos finalizados',
  })
  @ApiResponse({
    status: 200,
    description: 'Ganhos retornados com sucesso',
  })
  async getEarnings(): Promise<{
    totalGanhos: number;
    totalServicos: number;
    ganhosPorMes: { mes: number; ano: number; total: number }[];
  }> {
    return this.orcamentoService.getEarnings();
  }

  @Get(':nome/foto')
  @ApiOperation({
    summary: 'Retorna a foto do veículo do orçamento',
  })
  @ApiParam({ name: 'nome', type: String, description: 'Nome do arquivo da foto' })
  @ApiResponse({ status: 200, description: 'Foto retornada com sucesso' })
  @ApiResponse({ status: 404, description: 'Foto não encontrada' })
  async getFoto(@Param('nome') nome: string, @Res() res: Response) {
    const filePath = join(__dirname, '../../uploads/fotos', nome);
    try {
      await fs.access(filePath);
      res.sendFile(filePath);
    } catch (err: unknown) {
      res.status(404).json({ message: 'Arquivo não encontrado', error: err });
    }
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

  @Get(':placa/veiculo')
  async findByVeiculoPlaca(@Param('placa') placa: string) {
    const orcamentos = await this.orcamentoService.findByVeiculoPlaca(placa);
    return orcamentos;
  }

  @Patch(':id/foto')
  @UseInterceptors(FileInterceptor('foto', multerConfig))
  @ApiOperation({
    summary: 'Atualiza a foto do veículo do orçamento',
  })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiResponse({ status: 200, description: 'Foto atualizada com sucesso' })
  @ApiResponse({ status: 400, description: 'Erro ao atualizar foto' })
  @ApiResponse({ status: 404, description: 'Orçamento não encontrado' })
  async updateFoto(
    @Param('id') id: number,
    @UploadedFile() file: Express.Multer.File,
  ): Promise<Orcamento> {
    if (!file) {
      throw new BadRequestException('Arquivo de foto é obrigatório');
    }

    try {
      return await this.orcamentoService.updateFotoVeiculo(
        Number(id),
        file.filename,
      );
    } catch (error: unknown) {
      throw new BadRequestException(
        (error as Error).message || 'Erro ao atualizar foto',
      );
    }
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
