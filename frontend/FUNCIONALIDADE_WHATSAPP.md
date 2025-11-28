# 📱 Funcionalidade de Envio de Orçamento via WhatsApp

## 📋 Descrição

A funcionalidade permite enviar o orçamento completo diretamente para o WhatsApp do cliente com todos os detalhes formatados de forma profissional.

## ✅ O que é enviado

A mensagem do WhatsApp contém:
- ✅ Nome do cliente
- ✅ Dados do veículo (modelo e placa)
- ✅ Lista completa de peças com valores individuais
- ✅ Subtotal de peças
- ✅ Lista completa de serviços com valores individuais
- ✅ Subtotal de serviços
- ✅ Total geral do orçamento
- ✅ Validade do orçamento (7 dias)

## 🚀 Como Usar

### Na Tela de Orçamento:

1. Preencha todos os dados na aba **DADOS**:
   - CPF do Cliente
   - Nome do Cliente
   - **Telefone** (obrigatório para WhatsApp)
   - Modelo do Veículo
   - Placa

2. Adicione as peças na aba **PEÇAS**:
   - Descrição da peça
   - Valor unitário

3. Adicione os serviços na aba **SERVIÇOS**:
   - Descrição do serviço
   - Valor do serviço

4. Na aba **SERVIÇOS**, você verá dois botões:
   - **"Enviar Orçamento via WhatsApp"** (verde) - Abre o WhatsApp com a mensagem
   - **"Salvar"** (preto) - Salva o orçamento no banco de dados

5. Clique em **"Enviar Orçamento via WhatsApp"**

6. O sistema irá:
   - Validar todos os dados
   - Validar o número de telefone
   - Formatar a mensagem profissionalmente
   - Abrir o WhatsApp com a mensagem pronta

7. No WhatsApp:
   - A mensagem já estará escrita
   - Você pode editar se necessário
   - Clique em enviar

## 📝 Exemplo de Mensagem Enviada

```
🚗 *AUTOSMART - ORÇAMENTO*
━━━━━━━━━━━━━━━━━━━━━

👤 *Cliente:* João da Silva
🚙 *Veículo:* Honda Civic
🔖 *Placa:* ABC1234

━━━━━━━━━━━━━━━━━━━━━

🔧 *PEÇAS:*

1. Pastilha de freio
   💰 R$ 150,00

2. Óleo do motor
   💰 R$ 80,00

*Subtotal Peças:* R$ 230,00

━━━━━━━━━━━━━━━━━━━━━

⚙️ *SERVIÇOS:*

1. Troca de freio
   💰 R$ 120,00

2. Troca de óleo
   💰 R$ 50,00

*Subtotal Serviços:* R$ 170,00

━━━━━━━━━━━━━━━━━━━━━

💵 *TOTAL DO ORÇAMENTO:* R$ 400,00

━━━━━━━━━━━━━━━━━━━━━

📅 *Validade:* 7 dias

_Orçamento gerado pelo sistema AUTOSMART_
```

## ⚡ Validações

O sistema valida automaticamente:

1. ✅ CPF válido (11 dígitos)
2. ✅ Nome do cliente preenchido
3. ✅ **Telefone preenchido e válido** (mínimo 10 dígitos)
4. ✅ Modelo do veículo preenchido
5. ✅ Placa preenchida
6. ✅ Pelo menos 1 peça adicionada
7. ✅ Pelo menos 1 serviço adicionado

Se faltar algo, uma mensagem de erro é exibida e o WhatsApp não abre.

## 📱 Fluxo de Uso

```
[Usuário clica em "Enviar via WhatsApp"]
         ↓
[Validação de todos os dados]
         ↓
[Validação especial do telefone]
         ↓
[Formatação da mensagem]
         ↓
[Abertura do WhatsApp]
         ↓
[Mensagem pronta para enviar]
         ↓
[Usuário clica em enviar no WhatsApp]
```

## 🎨 Design do Botão

- **Cor:** Verde oficial do WhatsApp (#25D366)
- **Ícone:** Ícone do WhatsApp
- **Posição:** Acima do botão "Salvar", apenas na aba SERVIÇOS
- **Estado de loading:** Mostra indicador de carregamento quando clicado

## 🔧 Detalhes Técnicos

### Dependência Utilizada
```yaml
url_launcher: ^6.2.5
```

### Formato da URL do WhatsApp
```
https://wa.me/55[TELEFONE]?text=[MENSAGEM_CODIFICADA]
```

- O `55` é o código do Brasil
- O telefone é limpo (apenas números)
- A mensagem é codificada para URL

### Tratamento de Erros

O sistema trata:
- ❌ Dados obrigatórios não preenchidos
- ❌ Telefone inválido ou vazio
- ❌ WhatsApp não instalado no dispositivo
- ❌ Erro ao abrir o WhatsApp

Todos os erros são exibidos ao usuário com mensagens claras.

## 🚨 Observações Importantes

1. **Número brasileiro:** O sistema adiciona automaticamente o código do Brasil (55)

2. **WhatsApp instalado:** O WhatsApp deve estar instalado no dispositivo

3. **Não envia automaticamente:** A mensagem é apenas preparada, o usuário deve clicar em enviar

4. **Editável:** O usuário pode editar a mensagem no WhatsApp antes de enviar

5. **Múltiplos envios:** É possível enviar o orçamento várias vezes

6. **Independente do salvamento:** Não é necessário salvar o orçamento no banco para enviar via WhatsApp

## 💡 Vantagens

✅ **Rápido:** Cliente recebe instantaneamente
✅ **Profissional:** Mensagem bem formatada com emojis
✅ **Conveniente:** Abre direto no WhatsApp
✅ **Flexível:** Permite edição antes de enviar
✅ **Rastreável:** Fica no histórico do WhatsApp
✅ **Sem erro:** Validações evitam envios incorretos

## 🎯 Casos de Uso

1. **Orçamento rápido:** Enviar orçamento sem salvar no sistema
2. **Confirmação:** Cliente solicita orçamento por telefone
3. **Follow-up:** Reenviar orçamento atualizado
4. **Transparência:** Cliente vê todos os detalhes antes

## 🔄 Diferença entre Enviar WhatsApp e Salvar

| Ação | Enviar WhatsApp | Salvar |
|------|----------------|--------|
| **Valida dados** | ✅ Sim | ✅ Sim |
| **Requer telefone** | ✅ Obrigatório | ⚠️ Opcional |
| **Salva no banco** | ❌ Não | ✅ Sim |
| **Abre WhatsApp** | ✅ Sim | ❌ Não |
| **Pode fazer várias vezes** | ✅ Sim | ⚠️ Cria duplicatas |

## 📊 Layout Visual

```
┌──────────────────────────────────┐
│   [Área de totais]               │
└──────────────────────────────────┘
         
┌──────────────────────────────────┐
│ 💬 Enviar Orçamento via WhatsApp │  ← NOVO (Verde)
└──────────────────────────────────┘

┌──────────────────────────────────┐
│      Salvar / Próximo            │  ← Existente (Preto)
└──────────────────────────────────┘
```

---

**Desenvolvido para AUTOSMART App** 🚗💬

