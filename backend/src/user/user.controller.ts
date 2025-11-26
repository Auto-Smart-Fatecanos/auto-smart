import {
  Body,
  Controller,
  Param,
  Post,
  Put,
  ParseIntPipe,
} from '@nestjs/common';
import { UserService } from './user.service';
import { UserDto } from './user.dto';
import { User } from '@prisma/client';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiBody,
} from '@nestjs/swagger';

@ApiTags('Users')
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  @ApiOperation({ summary: 'Cria um novo usuário' })
  @ApiResponse({
    status: 201,
    description: 'Usuario criado com sucesso',
  })
  @ApiResponse({
    status: 400,
    description: 'Dados inválidos',
  })
  @ApiBody({ type: UserDto })
  async create(
    @Body() user: UserDto,
  ): Promise<Partial<Omit<User, 'levelAcesso'>>> {
    return this.userService.create(user);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Atualiza os dados de um usuário exisente' })
  @ApiParam({ name: 'id', type: Number, description: 'ID do usuário' })
  @ApiResponse({
    status: 200,
    description: 'Usuário atualizado com sucesso',
  })
  @ApiResponse({
    status: 404,
    description: 'Usuário não encontrado',
  })
  @ApiBody({ type: UserDto })
  async updateUser(
    @Param('id', ParseIntPipe) id: number,
    @Body() user: UserDto,
  ): Promise<void> {
    return this.userService.updateUser(id, user);
  }
}
