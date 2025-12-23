# RSpec Configuration

Este projeto utiliza RSpec para testes, configurado para funcionar com MongoDB/Mongoid.

## Gems Instaladas

- **rspec-rails**: Framework de testes
- **factory_bot_rails**: Criação de fixtures para testes
- **faker**: Geração de dados fake
- **database_cleaner-mongoid**: Limpeza do banco de dados entre testes
- **shoulda-matchers**: Matchers adicionais para testes
- **simplecov**: Cobertura de código

## Estrutura de Diretórios

```
spec/
├── factories/          # Definições de factories do FactoryBot
├── models/            # Testes de models
├── controllers/       # Testes de controllers
├── requests/          # Testes de requests/integração
├── support/           # Arquivos de configuração auxiliares
│   ├── factory_bot.rb
│   └── shoulda_matchers.rb
├── rails_helper.rb    # Configurações do Rails para testes
└── spec_helper.rb     # Configurações gerais do RSpec
```

## Executando os Testes

```bash
# Executar todos os testes
bundle exec rspec

# Executar um arquivo específico
bundle exec rspec spec/models/user_spec.rb

# Executar um teste específico
bundle exec rspec spec/models/user_spec.rb:10
```

## Cobertura de Código

A cobertura de código é gerada automaticamente pelo SimpleCov e pode ser visualizada em:
```
coverage/index.html
```

## Configurações

### Database Cleaner
Configurado para usar a estratégia `:deletion` com Mongoid.

### FactoryBot
Métodos disponíveis automaticamente nos testes (create, build, etc).

### Shoulda Matchers
Matchers para validações e associações do Mongoid.
