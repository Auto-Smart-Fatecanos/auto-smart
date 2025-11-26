import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsString,
  ValidateNested,
  ArrayMinSize,
  IsBoolean,
  IsEnum,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { TipoOrcamento } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

//dados de cada item
export class OrcamentoItemDto {
  @ApiProperty({ example: 'Troca de óleo' })
  @IsString()
  @IsNotEmpty()
  descricao: string;

  @ApiProperty({
    example: 'SERVICO',
    enum: TipoOrcamento,
    description: 'Tipo do item: SERVICO | PRODUTO',
  })
  @Transform(({ value }) => String(value).toUpperCase())
  @IsEnum(TipoOrcamento)
  tipoOrcamento: TipoOrcamento;

  @ApiProperty({ example: 120.5 })
  @IsNumber()
  @IsPositive()
  orcamentoValor: number;
}

//estruturar array pro orçamento
export class OrcamentoItensArrayDto {
  @ApiProperty({
    type: OrcamentoItemDto,
    isArray: true,
    example: [
      {
        descricao: 'Troca de óleo',
        tipoOrcamento: 'SERVICO',
        orcamentoValor: 120,
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrcamentoItemDto)
  @ArrayMinSize(1)
  orcamentoItens: OrcamentoItemDto[];
}

// dados pro orçamento
export class OrcamentoDto {
  @ApiProperty({ example: 1 })
  @IsInt()
  @IsPositive()
  clienteId: number;

  @ApiProperty({ example: 'ABC1234' })
  @IsString()
  @IsNotEmpty()
  placa: string;

  @ApiProperty({ example: 'Honda Civic' })
  @IsString()
  @IsNotEmpty()
  modelo: string;
}

// criar orçamento
export class CreateOrcamentoDto {
  @ApiProperty({
    type: OrcamentoDto,
    example: {
      clienteId: 1,
      placa: 'ABC1234',
      modelo: 'Civic',
    },
  })
  @ValidateNested()
  @Type(() => OrcamentoDto)
  Orcamento: OrcamentoDto;

  @ApiProperty({
    type: OrcamentoItensArrayDto,
    example: {
      orcamentoItens: [
        {
          descricao: 'Troca de óleo',
          tipoOrcamento: 'SERVICO',
          orcamentoValor: 120,
        },
      ],
    },
  })
  @ValidateNested()
  @Type(() => OrcamentoItensArrayDto)
  orcamentoItens: OrcamentoItensArrayDto;
}
//atualizar item que existe
export class UpdateOrcamentoItemDto {
  @ApiProperty({ example: 10 })
  @IsInt()
  @IsPositive()
  id: number;

  @ApiProperty({ example: 3 })
  @IsInt()
  @IsPositive()
  orcamentoId: number;

  @ApiProperty({ example: true })
  @IsBoolean()
  ativo: boolean;

  @ApiProperty({ example: 'Filtro de óleo' })
  @IsString()
  @IsNotEmpty()
  descricao: string;

  @ApiProperty({
    example: 'PRODUTO',
    enum: TipoOrcamento,
  })
  @Transform(({ value }) => String(value).toUpperCase())
  @IsEnum(TipoOrcamento)
  tipoOrcamento: TipoOrcamento;

  @ApiProperty({ example: 89.9 })
  @IsNumber()
  @IsPositive()
  orcamentoValor: number;
}

// Atualizar orcamento item
export class UpdateOrcamentoItensDto {
  @ApiProperty({
    type: UpdateOrcamentoItemDto,
    isArray: true,
    example: [
      {
        id: 5,
        orcamentoId: 1,
        ativo: true,
        descricao: 'Correia dentada',
        tipoOrcamento: 'PRODUTO',
        orcamentoValor: 350,
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => UpdateOrcamentoItemDto)
  @ArrayMinSize(1)
  itens: UpdateOrcamentoItemDto[];
}
