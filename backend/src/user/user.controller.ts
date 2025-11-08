import { Body, Controller, Param, Post, Put } from '@nestjs/common';
import { UserService } from './user.service';
import { UserDto } from './user.dto';
import { User } from '@prisma/client';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  async create(
    @Body()
    user: UserDto,
  ): Promise<Partial<Omit<User, 'levelAcesso'>>> {
    return this.userService.create(user);
  }

  @Put(':id/')
  async updateUser(
    @Param('id') id: number,
    @Body() user: UserDto,
  ): Promise<void> {
    return this.userService.updateUser(id, user);
  }
}
