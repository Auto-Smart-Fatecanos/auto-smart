import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, Length } from 'class-validator';

export class CreateClienteDto {
  @ApiProperty({ example: 'João da Silva' })
  @IsString()
  @IsNotEmpty()
  nome: string;

  @ApiProperty({ example: '12345678900' })
  @IsString()
  @IsNotEmpty()
  @Length(11, 11, { message: 'O CPF deve conter exatamente 11 dígitos.' })
  cpf: string;

  @ApiProperty({ example: '11999999999' })
  @IsString()
  @IsNotEmpty()
  telefone: string;
}
