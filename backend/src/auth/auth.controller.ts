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

export class LoginDto {
  @IsNotEmpty()
  cpf: string;

  @IsNotEmpty()
  password: string;
}

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @HttpCode(200)
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
  async refresh(@Req() req) {
    console.log(req.user);
    return this.authService.refreshAccessToken(
      req.user.cpf,
      req.user.refreshToken,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  @HttpCode(200)
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
