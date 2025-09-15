# Sistema de Pedidos

## 📋 Descrição
Sistema de gestão de pedidos de venda desenvolvido em Delphi com MySQL, seguindo alguns requisitos. Implementa conceitos de POO, padrões de arquitetura e boas práticas de desenvolvimento.

## 🏗️ Arquitetura
O projeto segue uma arquitetura em camadas baseada em Clean Architecture:

- **UI** (`src/ui/`): Interface do usuário (Forms)
- **Application** (`src/app/`): Serviços de aplicação e tipos de domínio
- **Infrastructure** (`src/infra/`): Acesso a dados e configurações

### Padrões Implementados
- **Repository Pattern**: Abstração do acesso a dados
- **Dependency Injection**: Injeção de dependências via construtor
- **SOLID Principles**: Especialmente SRP, OCP e DIP
- **Clean Code**: Código limpo e bem documentado

## 🚀 Funcionalidades Implementadas

### ✅ Requisitos Atendidos
- [x] **1-3**: Interface para informar cliente e produtos
- [x] **4**: Tabelas criadas com PKs, FKs e índices
- [x] **5**: Entrada de produto (código, quantidade, valor unitário)
- [x] **6**: Botão para inserir produtos no grid
- [x] **7**: Grid com código, descrição, quantidade, vlr. unitário e total
- [x] **8**: Navegação com setas no grid
- [x] **9**: ENTER para editar produtos no grid
- [x] **10**: DEL para apagar produtos com confirmação
- [x] **11**: Produtos repetidos permitidos
- [x] **12**: Valor total do pedido no rodapé
- [x] **13**: Botão GRAVAR PEDIDO com 2 tabelas
- [x] **14**: Estrutura da tabela pedidos
- [x] **15**: Estrutura da tabela pedidos_produtos
- [x] **16**: Transações e tratamento de erros
- [x] **17**: Número sequencial crescente
- [x] **18**: PK da tabela pedidos (sem duplicidade)
- [x] **19**: PK autoincrement nos produtos
- [x] **20**: FKs entre tabelas
- [x] **21**: Índices necessários
- [x] **22**: Botão carregar pedidos
- [x] **23**: Botão cancelar pedidos
- [x] **24**: Configuração dinâmica via INI
- [x] **25**: Biblioteca MySQL incluída
- [x] **26**: FireDAC para acesso aos dados

## 🗃️ Estrutura do Banco de Dados

### Tabelas Principais
```sql
-- Clientes (25 registros incluídos)
clientes (codigo, nome, cidade, uf)

-- Produtos (25 registros incluídos)  
produtos (codigo, descricao, preco_venda)

-- Pedidos (dados gerais)
pedidos (numero_pedido, data_emissao, codigo_cliente, valor_total)

-- Itens dos pedidos
pedidos_produtos (autoincrem, numero_pedido, codigo_produto, quantidade, vlr_unitario, vlr_total)

-- Controle de numeração
controle_numeracao (tabela, ultimo_numero)
```

### Recursos Avançados
- **Stored Procedures**: Geração segura de números sequenciais
- **Triggers**: Cálculo automático de totais
- **Views**: Relatórios de pedidos completos
- **Índices**: Performance otimizada
- **Foreign Keys**: Integridade referencial

## ⚙️ Configuração e Instalação

### Pré-requisitos
- Delphi 10.4 Sydney ou superior
- MySQL 8.0 ou superior
- FireDAC (incluído no Delphi)

### Configuração do Banco
1. **Instalar MySQL**: Baixe e instale o MySQL Server
2. **Executar Script**: Execute o arquivo `database_dump.sql` no MySQL
3. **Configurar Acesso**: Edite o arquivo `config.ini` com suas credenciais

### Configuração da Aplicação
1. **Clone do Repositório**:
   ```bash
   git clone [URL_DO_REPOSITORIO]
   cd Pedidos
   ```

2. **Configurar Banco** (`config.ini`):
```ini
[DATABASE]
Server=localhost
Port=3306
Database=pedidos_wk
Username=root
Password=sua_senha
LibraryPath=C:\Program Files\MySQL\MySQL Server 8.0\lib\libmysql.dll
```

3. **Compilar**: Abra `src/PedidoVenda.dproj` no Delphi e compile

4. **Executar**: Execute o arquivo gerado em `src/Win32/Debug/`

## 🎮 Como Usar

### Operações Básicas
1. **Novo Pedido**: F2 ou botão "Novo Pedido"
2. **Informar Cliente**: Digite o código do cliente e pressione ENTER
3. **Adicionar Produtos**: 
   - Digite código do produto + ENTER
   - Informe quantidade e valor unitário
   - Clique "Adicionar" ou pressione F10
4. **Gravar Pedido**: F5 ou botão "Gravar Pedido"

### Navegação no Grid
- **Setas**: ↑↓ para navegar
- **ENTER**: Editar item selecionado
- **DELETE**: Excluir item (com confirmação)
- **Double-click**: Editar item

### Atalhos de Teclado
- **F2**: Novo Pedido
- **F3**: Carregar Pedido
- **F5**: Gravar Pedido
- **F8**: Cancelar Pedido
- **F9**: Limpar Item
- **F10**: Adicionar Item
- **ESC**: Fechar aplicação

### Carregar/Cancelar Pedidos
1. **Carregar**: Botão disponível quando não há cliente informado
2. **Cancelar**: Botão disponível quando não há cliente informado
3. Ambos solicitam o número do pedido

## 📁 Estrutura do Projeto

```
Pedidos/
├── src/
│   ├── app/                    # Camada de aplicação
│   │   ├── uOrderService.pas   # Serviço de pedidos
│   │   └── uOrderTypes.pas     # Tipos de domínio
│   ├── infra/                  # Camada de infraestrutura
│   │   ├── uDmDB.pas/.dfm      # DataModule de conexão
│   │   └── uOrderRepository.pas # Repository de pedidos
│   ├── ui/                     # Camada de interface
│   │   ├── uFrmPedidoVenda.pas # Form principal
│   │   └── uFrmPedidoVenda.dfm # Layout do form
│   ├── PedidoVenda.dpr         # Projeto principal
│   └── PedidoVenda.dproj       # Arquivo de projeto
├── config.ini                 # Configuração da aplicação
├── database_dump.sql           # Script de criação do banco
├── libmysql.dll               # Biblioteca MySQL (incluir)
└── README.md                  # Este arquivo
```

## 💾 Distribuição

### Arquivos Necessários
```
PedidoVenda.exe     # Executável principal
config.ini          # Configuração do banco
libmysql.dll        # Biblioteca MySQL
```

### Script SQL
O arquivo `database_dump.sql` contém:
- Criação de todas as tabelas
- Índices e relacionamentos
- 25+ registros de clientes
- 25+ registros de produtos
- Stored procedures e triggers
- Views para relatórios

## 🔧 Recursos Técnicos

### Componentes Utilizados (Nativos Delphi)
- **TFDConnection**: Conexão com MySQL
- **TFDQuery**: Execução de comandos SQL
- **TStringGrid**: Grid de itens do pedido
- **TLabeledEdit**: Campos de entrada
- **TGroupBox**: Agrupamento visual
- **TPanel**: Organização do layout

### Tratamento de Erros
- Try/except em todas as operações críticas
- Validações de entrada de dados
- Mensagens de erro amigáveis
- Rollback automático em transações

### Performance
- Índices otimizados no banco
- Prepared statements
- Connection pooling
- Triggers para cálculos automáticos

## 🎯 Avaliação Técnica

### Conceitos Aplicados
- **Orientação a Objetos**: Classes, herança, polimorfismo
- **Padrões de Projeto**: Repository, Dependency Injection
- **Clean Code**: Nomes descritivos, funções pequenas, comentários úteis
- **SOLID**: Responsabilidade única, aberto/fechado, inversão de dependência
- **Tratamento de Erros**: Exceções, validações, feedback ao usuário
- **SQL Avançado**: Procedures, triggers, views, índices

### Qualidades do Código
- Separação clara de responsabilidades
- Fácil manutenção e extensão
- Testabilidade (repositório abstrato)
- Configuração externa via INI
- Interface intuitiva e responsiva

