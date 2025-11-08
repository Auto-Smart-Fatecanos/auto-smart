import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { UserService } from '../user/user.service';
import { User } from '@prisma/client';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async validateUser(cpf: string, password: string): Promise<any> {
    const user = await this.userService.findByCpf(cpf);

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid)
      throw new UnauthorizedException('Invalid credentials');

    const { password: _, ...result } = user;
    return result;
  }

  async login(user: User) {
    const payload = { cpf: user.cpf };
    const accessToken = this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_SECRET'),
      expiresIn: this.configService.get('JWT_EXPIRES_IN'),
    });

    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_SECRET'),
      expiresIn: '7d',
    });

    await this.userService.updateRefreshToken(user.cpf, refreshToken);

    const data: Partial<User> = { ...user };
    delete data.password;
    delete data.refreshToken;
    delete data.levelAcesso;

    return {
      access_token: accessToken,
      refresh_token: refreshToken,
      user: data,
    };
  }

  async refreshAccessToken(cpf: string, refreshToken: string) {
    const user = await this.userService.findByCpf(cpf);

    if (!user || !user.refreshToken) {
      throw new UnauthorizedException('Acesso negado');
    }

    const refreshTokenMatches = await bcrypt.compare(
      refreshToken,
      user.refreshToken,
    );

    if (!refreshTokenMatches) {
      throw new UnauthorizedException('Acesso negado');
    }

    const payload = { cpf: user.cpf };

    const accessToken = this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_SECRET'),
      expiresIn: '15m',
    });

    return {
      access_token: accessToken,
    };
  }

  async logout(cpf: string) {
    await this.userService.updateRefreshToken(cpf, null);
    return { message: 'Logout realizado com sucesso' };
  }
}
