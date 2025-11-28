## Rodando projeto em desenvolvimento

```bash
# instala as dependências do projeto
$ npm install

# Crie as tabela no banco de dados
$ npx prisma db push

# Crie o prisma-client
$ npx prisma generate

# Rode o servidor em ambinte de teste
$ npm run start:dev

# Populando o banco de dados
$ npm run seed

# Para ver as tabelas do banco de dados com o prisma studio
$ npx prisma studio
```

## Compile e rode o projeto

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```
## Pendências Back-End

### Geral
- [ ] Adicionar data_criacao nos models que não tem
### Cliente
- [ ] Relacionar tabela com a loja
- [ ] O CPF pode ser repetido em lojas diferentes

### Orçamento
- [ ] O orçamento também precisa se relacionar com a loja, permitindo que outros usuários dela também veja eles

