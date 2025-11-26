import {
  IsInt,
  IsNotEmpty,
  IsPositive,
  IsString,
  Length,
  IsEmail,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UserDto {
  @ApiProperty({ example: 'Darlan' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Junior' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({ example: 'darlanj207@email.com' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @IsNotEmpty()
  password: string;

  @ApiProperty({ example: '12345678900' })
  @IsString()
  @IsNotEmpty()
  @Length(11, 16, { message: 'O CPF deve ter 11 dígitos.' })
  cpf: string;

  @ApiProperty({ example: '11999999999' })
  @IsString()
  @IsNotEmpty()
  phoneNumber: string;

  @ApiProperty({ example: 1 })
  @IsInt()
  @IsPositive()
  storeId: number;
}
