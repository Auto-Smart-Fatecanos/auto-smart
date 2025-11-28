import * as dotenv from 'dotenv';
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

// Carregar variáveis de ambiente do arquivo .env
dotenv.config();

const prisma = new PrismaClient();

async function main() {
  // data cleanup
  await prisma.orcamentoItem.deleteMany();
  await prisma.orcamento.deleteMany();
  await prisma.cliente.deleteMany();
  await prisma.user.deleteMany();
  await prisma.store.deleteMany();
  

  //create a store
  const store = await prisma.store.create({
    data: {
      name: 'Loja Principal',
      imagePath: '/uploads/store-logo.png',
    },
  });

  //create user
  const hashedPassword = await bcrypt.hash('123456', 10);

  const user = await prisma.user.create({
    data: {
      firstName: 'Jonathan',
      lastName: 'Santana',
      email: 'jonathan@example.com',
      password: hashedPassword,
      cpf: '12345678900',
      phoneNumber: '11999999999',
      storeId: store.id,
    },
  });

  const cliente = await prisma.cliente.create({
    data: {
      nome: 'João da Silva',
      cpf: '25282604078',
      telefone: '11999999999',
    },
  });

  const orcamento = await prisma.orcamento.create({
    data: {
      clienteId: cliente.id,
      placa: '12345678900',
      modelo: '12345678900',
      storeId: store.id,
      criadoPor: user.id,
    },
  });

  await prisma.orcamentoItem.createMany({
    data: [
      {
        tipoOrcamento: 'SERVICO',
        orcamentoValor: 100,
        orcamentoId: orcamento.id,
        descricao: 'Serviço de manutenção',
      },
      {
        tipoOrcamento: 'SERVICO',
        orcamentoValor: 200,
        orcamentoId: orcamento.id,
        descricao: 'Trocar rolamento',
      },
      {
        tipoOrcamento: 'PECA',
        orcamentoValor: 200,
        orcamentoId: orcamento.id,
        descricao: 'Rolamento 1',
      },
      {
        tipoOrcamento: 'PECA',
        orcamentoValor: 150,
        orcamentoId: orcamento.id,
        descricao: 'Cabo elétrico',
      },
    ],
  });
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('Erro no seed:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
