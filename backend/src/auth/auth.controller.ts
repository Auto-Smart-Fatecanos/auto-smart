import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpException,
  HttpStatus,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { JwtRefreshGuard } from './guards/jwt-refresh.guard';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { IsNotEmpty } from 'class-validator';
import { User } from '@prisma/client';
import { ApiProperty, ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({ example: '12345678900' })
  @IsNotEmpty()
  cpf: string;

  @ApiProperty({ example: '123456' })
  @IsNotEmpty()
  password: string;
}

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Realiza Operação de login com CPF e senha' })
  @ApiResponse({ status: 200, description: 'Login realizado com sucesso' })
  @ApiResponse({ status: 401, description: 'Credenciais inválidas' })
  async login(@Body() loginDto: LoginDto) {
    const user: User = await this.authService.validateUser(
      loginDto.cpf,
      loginDto.password,
    );

    return this.authService.login(user);
  }

  @UseGuards(JwtRefreshGuard)
  @Post('refresh')
  @HttpCode(200)
  @ApiOperation({ summary: 'Gera novo access token usando refresh token' })
  @ApiResponse({ status: 200, description: 'Token renovado com sucesso' })
  @ApiResponse({ status: 401, description: 'Refresh token inválido' })
  async refresh(@Req() req) {
    return this.authService.refreshAccessToken(
      req.user.cpf,
      req.user.refreshToken,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  @HttpCode(200)
  @ApiOperation({ summary: 'Invalida o refresh token do usuário' })
  @ApiResponse({ status: 200, description: 'Logout realizado com sucesso' })
  @ApiResponse({ status: 401, description: 'Token inválido ou ausente' })
  async logout(@Req() req) {
    const user = req.user as { cpf?: string };

    if (!user?.cpf) {
      throw new HttpException(
        'User CPF not found in request',
        HttpStatus.UNAUTHORIZED,
      );
    }

    await this.authService.logout(user.cpf);

    return { message: 'Logged out successfully' };
  }
}
