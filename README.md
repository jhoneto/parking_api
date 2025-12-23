# Parking API

API REST para gerenciamento de estacionamento desenvolvida com Ruby on Rails e MongoDB.

## Versões

- Ruby: 3.4.6
- Rails: 8.0.4
- MongoDB: 7

## Desenvolvimento com DevContainer

Este projeto está configurado para usar DevContainers, facilitando o desenvolvimento com Docker.

### Pré-requisitos

- Docker
- Docker Compose
- VS Code com extensão Remote - Containers

### Como Usar

1. Abra o projeto no VS Code
2. Pressione `F1` e selecione "Dev Containers: Reopen in Container"
3. Aguarde a construção e inicialização dos containers
4. Após abrir o container, inicie o servidor Rails:
   - **Via terminal**: `./bin/dev-server`
   - **Via VS Code**: Pressione `Ctrl+Shift+P` → "Tasks: Run Task" → "Start Rails Server"
5. A aplicação estará disponível em `http://localhost:3000`

O DevContainer irá:
- Construir a imagem Docker usando `Dockerfile.dev`
- Iniciar o container Rails API e MongoDB
- Instalar as dependências automaticamente com `bundle install`
- Configurar as extensões do VS Code
- Manter os containers rodando em background

## Desenvolvimento Local (sem DevContainer)

### Usando Docker Compose

```bash
# Construir e iniciar os containers
docker-compose up --build

# Parar os containers
docker-compose down

# Reconstruir os containers
docker-compose up --build --force-recreate
```

### Configuração Manual

1. Instale o Ruby 3.4.6
2. Instale o MongoDB 7
3. Configure as variáveis de ambiente (veja `.env.example`)
4. Execute:

```bash
bundle install
rails server
```

## Variáveis de Ambiente

Copie o arquivo `.env.example` para `.env` e configure:

```bash
cp .env.example .env
```

Variáveis disponíveis:
- `MONGODB_HOST` - Host do MongoDB (padrão: mongo)
- `MONGODB_PORT` - Porta do MongoDB (padrão: 27017)
- `API_TOKEN` - Token para autenticação da API
- `RAILS_ENV` - Ambiente Rails (development/test/production)

## Autenticação

Todos os endpoints da API requerem autenticação via Bearer Token.

Inclua o header:
```
Authorization: Bearer seu_token_aqui
```

## Testes

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes com coverage
bundle exec rspec --format documentation

# Executar teste específico
bundle exec rspec spec/models/parking_spec.rb
```

O relatório de cobertura estará disponível em `coverage/index.html`.

## Estrutura do Projeto

```
.
├── app/
│   ├── controllers/     # Controllers da API
│   └── models/          # Models Mongoid
├── config/
│   └── mongoid.yml      # Configuração do MongoDB
├── spec/
│   ├── factories/       # FactoryBot factories
│   ├── models/          # Testes de models
│   ├── requests/        # Testes de requests
│   └── support/         # Helpers e configurações de teste
├── .devcontainer/       # Configuração do DevContainer
├── Dockerfile           # Dockerfile de produção
├── Dockerfile.dev       # Dockerfile de desenvolvimento
└── docker-compose.yml   # Configuração Docker Compose
```

## Models

### Parking

Campos:
- `plate` (String, obrigatório) - Placa do veículo no formato AAA-9999
- `entry_time` (DateTime, obrigatório) - Horário de entrada
- `exit_time` (DateTime) - Horário de saída
- `paid` (Boolean, default: false) - Status de pagamento

## Endpoints

Em desenvolvimento...
