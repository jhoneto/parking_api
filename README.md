# Parking API

API REST para gerenciamento de estacionamento desenvolvida com Ruby on Rails e MongoDB.

## Versões

- Ruby: 3.4.6
- Rails: 8.0.4
- MongoDB: 7


## Desenvolvimento Local

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

Caso deseje desabilitar a autenticação, configure a variável de ambiente `SKIP_AUTHENTICATION` como `true`.

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

### 1. Criar Estacionamento (Entrada)

**POST** `/parking`

Registra a entrada de um veículo no estacionamento.

```bash
curl -X POST http://localhost:3000/parking \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{
    "parking": {
      "plate": "ABC-1234"
    }
  }'
```

**Resposta (201 Created):**
```json
{
  "id": "676957c3f432f70b6b8b4567"
}
```

---

### 2. Consultar Estacionamentos por Placa

**GET** `/parking/:plate`

Retorna o histórico de estacionamentos de uma placa específica, ordenado pela data de entrada (mais recente primeiro).

```bash
curl -X GET http://localhost:3000/parking/ABC-1234 \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

**Resposta (200 OK):**
```json
[
  {
    "id": "676957c3f432f70b6b8b4567",
    "plate": "ABC-1234",
    "entry_time": "2025-12-23T10:30:00Z",
    "exit_time": null,
    "paid": false
  }
]
```

---

### 3. Registrar Pagamento

**PUT** `/parking/:plate/pay`

Registra o pagamento do estacionamento para uma placa específica.

```bash
curl -X PUT http://localhost:3000/parking/ABC-1234/pay \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

**Resposta (200 OK):**
```
(sem corpo - apenas status 200)
```

---

### 4. Registrar Saída

**PUT** `/parking/:plate/out`

Registra a saída do veículo do estacionamento.

```bash
curl -X PUT http://localhost:3000/parking/ABC-1234/out \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

**Resposta (200 OK):**
```
(sem corpo - apenas status 200)
```

---

### Fluxo Completo de Uso

```bash
# 1. Registrar entrada do veículo
curl -X POST http://localhost:3000/parking \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -d '{"parking": {"plate": "ABC-1234"}}'

# 2. Consultar histórico da placa
curl -X GET http://localhost:3000/parking/ABC-1234 \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"

# 3. Registrar pagamento
curl -X PUT http://localhost:3000/parking/ABC-1234/pay \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"

# 4. Registrar saída
curl -X PUT http://localhost:3000/parking/ABC-1234/out \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```


