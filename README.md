# Controle Financeiro

Um aplicativo Flutter para gerenciar vendas e compras, com suporte a parcelas, edição, exclusão e encerramento de transações.

## Funcionalidades

- **Registro de Vendas/Compras**: Adicione vendas (clientes) ou compras (fornecedores) com valor total, parcela inicial (opcional), contato e data.
- **Gerenciamento de Parcelas**: Adicione parcelas com valor sugerido baseado na última paga.
- **Edição e Exclusão**: Edite ou exclua vendas/compras não encerradas.
- **Encerramento**: Marque transações como encerradas quando o saldo devedor for zero.
- **Temas**: Alterne entre temas claro e escuro.
- **Persistencia**: Dados salvos em SQLite com suporte a migrações.

## Estrutura do Projeto

```
lib/
├── pages/
│   ├── home_page.dart        # Estrutura principal com AppBar e TabBar
│   ├── vendas_page.dart      # Lógica e UI da aba de vendas
│   └── compras_page.dart     # Lógica e UI da aba de compras
├── services/
│   └── database_helper.dart  # Gerenciamento do banco SQLite
├── widgets/
│   ├── form_card.dart        # Formulário reutilizável para vendas/compras
│   ├── list_card.dart        # Lista reutilizável de vendas/compras
│   └── dialogs.dart          # Diálogos para adicionar parcela, editar e excluir
└── main.dart                 # Configuração do app e temas
```

## Pré-requisitos

- Flutter SDK (3.20 ou superior)
- Dart (3.6.0)
- Dispositivo/emulador Android/iOS ou ambiente de desenvolvimento configurado

## Instalação

1. Clone o repositório:

   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd flutter_controle_financeiro
   ```

2. Instale as dependências:

   ```bash
   flutter pub get
   ```

3. Verifique o `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     sqflite: ^2.3.0
     path: ^1.8.3
   ```

## Execução

1. Conecte um dispositivo ou inicie um emulador.
2. Execute o aplicativo:

   ```bash
   flutter run
   ```

3. Para limpar o cache (se necessário):
   ```bash
   flutter clean
   flutter pub get
   ```

## Uso

- **Abas**: Navegue entre "Vendas" e "Compras" via `TabBar`.
- **Registro**: Preencha o formulário (valor total e cliente/fornecedor obrigatórios) e clique em "Registrar".
- **Lista**: Visualize transações com saldo devedor, data e contato. Use ícones para:
  - Editar (`Icons.edit`)
  - Adicionar parcela (`Icons.add_circle`)
  - Encerrar (`Icons.lock`, se saldo zero)
  - Excluir (`Icons.delete`)
- **Temas**: Alterne entre claro/escuro via ícone na `AppBar`.

## Notas

- **Banco de Dados**: Usa SQLite com migração para adicionar a coluna `encerrada` (versão 2).
- **Design**: Bordas arredondadas (`BorderRadius.circular(12)`), gradientes suaves, adaptado a temas claro/escuro.
- **Componentização**: Código organizado por responsabilidades, com widgets reutilizáveis.

## Possíveis Melhorias

- Máscara de moeda nos campos numéricos.
- Validação para evitar parcelas acima do saldo devedor.
- Persistência de tema com `shared_preferences`.
- Filtros ou busca por vendas/compras.
- Exportação de dados para relatórios.

## Licença

MIT License
