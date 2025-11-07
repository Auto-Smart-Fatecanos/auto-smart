import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Delete,
  BadRequestException,
  Query,
  // UseGuards,
} from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import type { Orcamento, OrcamentoItem } from '@prisma/client';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { OrcamentoDto, OrcamentoItensArrayDto } from './orcamento.dto';
// import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

// @UseGuards(JwtAuthGuard)
@Controller('orcamentos')
export class OrcamentoController {
  constructor(private readonly orcamentoService: OrcamentoService) {}

  @Post()
  async create(
    @Body()
    body,
  ): Promise<Orcamento & { orcamentoItems: OrcamentoItem[] }> {
    const { orcamentoItens, ...orcamento } = body;

    console.log(orcamentoItens, orcamento);

    const orcamentoInstance = plainToInstance(OrcamentoDto, orcamento);
    const orcamentoErrors = await validate(orcamentoInstance, {
      whitelist: true,
    });

    if (orcamentoErrors.length > 0) {
      throw new BadRequestException(orcamentoErrors);
    }

    const itensInstance = plainToInstance(OrcamentoItensArrayDto, {
      orcamentoItens: orcamentoItens as OrcamentoItem[],
    });

    const itensErrors = await validate(itensInstance);
    if (itensErrors.length > 0) {
      throw new BadRequestException(itensErrors);
    }

    return this.orcamentoService.create({
      orcamento: orcamento as Orcamento,
      orcamentoItens: orcamentoItens as OrcamentoItem[],
    });
  }

  @Get()
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

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Orcamento | null> {
    return this.orcamentoService.findOne(Number(id));
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Orcamento> {
    return this.orcamentoService.remove(Number(id));
  }
}
