import { CheckListType } from '@prisma/client';
import { Transform } from 'class-transformer';
import { IsEnum, IsNotEmpty, IsPositive, IsString } from 'class-validator';

export class CreateChecklistDto {
  @IsNotEmpty()
  @IsPositive()
  orcamentoId: number;

  @IsString()
  observacoes: string;

  @Transform(({ value }) => String(value).toUpperCase())
  @IsEnum(CheckListType, {
    message: `type deve ser um dos seguintes valores: ${Object.values(CheckListType).join(', ')}`,
  })
  tipo: CheckListType;
}
