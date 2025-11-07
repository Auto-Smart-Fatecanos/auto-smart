import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsString,
  ValidateNested,
  ArrayMinSize,
} from 'class-validator';
import { Type } from 'class-transformer';
import { TipoOrcamento } from '@prisma/client';

export class OrcamentoItemDto {
  @IsString()
  @IsNotEmpty()
  descricao: string;

  @IsString()
  @IsNotEmpty()
  tipoOrcamento: TipoOrcamento;

  @IsNumber()
  @IsPositive()
  orcamentoValor: number;
}

export class OrcamentoItensArrayDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrcamentoItemDto)
  @ArrayMinSize(1, { message: 'Deve haver pelo menos um item no orçamento' })
  orcamentoItens: OrcamentoItemDto[];
}

export class OrcamentoDto {
  @IsInt()
  @IsPositive()
  clienteId: number;

  @IsString()
  @IsNotEmpty()
  placa: string;

  @IsString()
  @IsNotEmpty()
  modelo: string;
}

export class CreateOrcamentoDto {
  Orcamento: OrcamentoDto;

  @ValidateNested()
  @Type(() => OrcamentoItensArrayDto)
  orcamentoItens: OrcamentoItensArrayDto;
}
