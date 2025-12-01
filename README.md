# 📱 AUTOSMART App - Sistema de Gestão de Serviços

<div align="center">
  <img src="frontend/assets/images/logo.png" alt="AUTOSMART App Logo" width="150" height="150">
  
  **Aplicação mobile para gestão de serviços automotivos**
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com)
  [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)

</div>

---

## 🚀 Sobre o Projeto

Sistema completo para gestão de serviços automotivos, permitindo controle de orçamentos, clientes e status de serviços de forma intuitiva e eficiente.

### ✨ Funcionalidades

- 🏠 **Dashboard** - Visão geral dos serviços com filtros por status
- 🔍 **Busca** - Pesquisa avançada de serviços e veículos
- 💰 **Orçamentos** - Criação e gerenciamento de orçamentos
- ✅ **Check-in** - Registro de entrada de veículos
- 📊 **Relatórios** - Estatísticas e ganhos
- 👤 **Perfil** - Gerenciamento de dados pessoais
- 📱 **Suporte WhatsApp** - Contato direto com suporte (horário comercial)

## 🛠️ Tecnologias

**Frontend:** Flutter + Material Design 3  
**Backend:** NestJS + Prisma 
**Banco de Dados:** Postgres
**Autenticação:** JWT

## 📦 Instalação

### Pré-requisitos

- Flutter SDK (3.9.0+)
- Node.js (18+)
- PgAdmin 4
- Git

### Backend

```bash
cd backend
npm install
cp .env.example .env
# Configure o .env com credenciais do MySQL
npm run start:dev
```

Servidor: `http://localhost:3000`

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

### Configuração do Frontend

Edite `frontend/lib/features/auth/data/auth_service.dart`:

```dart
// Para emulador Android
static const String baseUrl = 'http://10.0.2.2:3000/auth';

// Para dispositivo físico (use o IP da sua máquina)
static const String baseUrl = 'http://192.168.1.100:3000/auth';
```

## 🔧 Scripts Úteis

### Backend
```bash
npm run start:dev     # Desenvolvimento
npm run build         # Build
npm run test          # Testes
```

### Frontend
```bash
flutter run           # Executar app
flutter build apk     # Gerar APK
flutter clean         # Limpar cache
flutter doctor        # Verificar instalação
```

## 👥 Equipe

Desenvolvido por estudantes do **5º semestre de Desenvolvimento de Software Multiplataforma (DSM)**.

## 📄 Licença

Este projeto está sob a licença MIT.

