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
} from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import { Status, type Orcamento, type OrcamentoItem } from '@prisma/client';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { OrcamentoDto, OrcamentoItensArrayDto } from './orcamento.dto';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { UserService } from 'src/user/user.service';

@UseGuards(JwtAuthGuard)
@Controller('orcamentos')
export class OrcamentoController {
  constructor(
    private readonly orcamentoService: OrcamentoService,
    private readonly userService: UserService,
  ) {}

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

  @Patch(':id/status')
  async updateStatus(@Param('id') id: number, @Body('status') status: Status) {
    if (status === undefined) {
      throw new BadRequestException('Status é obrigatório');
    }
    return this.orcamentoService.updateStatus(id, status);
  }
}
