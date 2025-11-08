import { Module } from '@nestjs/common';
import { OrcamentoService } from './orcamento.service';
import { OrcamentoController } from './orcamento.controller';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuthModule } from '../auth/auth.module';
import { UserService } from 'src/user/user.service';

@Module({
  imports: [AuthModule],
  providers: [OrcamentoService, PrismaService, UserService],
  controllers: [OrcamentoController],
})
export class OrcamentoModule {}
