import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Length } from 'class-validator';

export class UpdateClienteDto {
  @ApiPropertyOptional({ example: 'Jefferson Atualizado' })
  @IsString()
  @IsOptional()
  nome?: string;

  @ApiPropertyOptional({ example: '12345678900' })
  @IsString()
  @Length(11, 11, { message: 'O CPF deve conter 11 dígitos.' })
  @IsOptional()
  cpf?: string;

  @ApiPropertyOptional({ example: '11999999999' })
  @IsString()
  @IsOptional()
  telefone?: string;
}
