import {
  Controller,
  Get,
  Post,
  Body,
  UseInterceptors,
  UploadedFiles,
  Req,
  UseGuards,
  UnauthorizedException,
} from '@nestjs/common';
import { ChecklistService } from './checklist.service';
import { AnyFilesInterceptor } from '@nestjs/platform-express';
import { CreateChecklistDto } from './dto/create-checklist.dto';
import { AuthGuard } from '@nestjs/passport';
import type { Request } from 'express';
import { use } from 'passport';

// NÃO ESQUECER DO AUTH GUARDS
@Controller('checklist')
export class ChecklistController {
  constructor(private readonly checklistService: ChecklistService) {}

  @Post()
  @UseGuards(AuthGuard('jwt'))
  @UseInterceptors(AnyFilesInterceptor())
  async upload(
    @UploadedFiles() files: Express.Multer.File[],
    @Body() body: CreateChecklistDto,
    @Req() req: Request,
  ) {
    const { cpf } = req.user as { cpf: string };

    if (!cpf) throw new UnauthorizedException('Usuário não autenticado');

    const result = await this.checklistService.createChecklist(
      body,
      files,
      cpf,
    );

    return result;
  }

  @Get(':id')
  findChekList() {
    return {};
  }
}
