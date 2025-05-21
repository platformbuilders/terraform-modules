# Módulo Azure Redis Cache

Este módulo Terraform cria um Redis Cache na Azure com suporte a diferentes SKUs, configurações de segurança e backup.

## Recursos Criados

- Redis Cache
- Regras de Firewall (opcional)
- Agendamento de Patches (opcional)

## Uso

```hcl
module "redis" {
  source = "path/to/module"

  resource_group_name = "my-resource-group"
  location           = "eastus"
  redis_name         = "my-redis-cache"
  
  # Configuração básica
  capacity           = 1
  family             = "C"
  sku_name           = "Standard"
  
  # Configurações de segurança
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  
  # Configurações Premium (opcional)
  subnet_id              = module.subnet.private_subnet_ids["private1"]
  private_static_ip_address = "10.0.2.10"
  shard_count            = 2
  zones                  = ["1", "2", "3"]
  
  # Configurações do Redis
  redis_configuration = {
    maxmemory_reserved = 50
    maxmemory_delta    = 50
    maxmemory_policy   = "volatile-lru"
    rdb_backup_enabled = true
    rdb_backup_frequency = 60
    rdb_backup_max_snapshot_count = 1
  }
  
  # Regras de Firewall
  firewall_rules = {
    rule1 = {
      start_ip = "10.0.0.0"
      end_ip   = "10.0.255.255"
    }
  }
  
  # Agendamento de Patches
  patch_schedule = [
    {
      day_of_week    = "Sunday"
      start_hour_utc = 2
    }
  ]

  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| resource_group_name | Nome do Resource Group onde o Redis será criado | `string` | n/a | sim |
| location | Região Azure onde o Redis será criado | `string` | n/a | sim |
| redis_name | Nome do Redis Cache | `string` | n/a | sim |
| capacity | Tamanho do Redis Cache (0 = Basic, 1 = Standard, 2 = Premium) | `number` | `1` | não |
| family | Família do Redis Cache (C = Basic/Standard, P = Premium) | `string` | `"C"` | não |
| sku_name | SKU do Redis Cache (Basic, Standard, Premium) | `string` | `"Standard"` | não |
| enable_non_ssl_port | Habilita porta não-SSL (6379) | `bool` | `false` | não |
| minimum_tls_version | Versão mínima do TLS (1.0, 1.1, 1.2) | `string` | `"1.2"` | não |
| subnet_id | ID da subnet onde o Redis será criado (apenas para Premium) | `string` | `null` | não |
| private_static_ip_address | Endereço IP estático privado (apenas para Premium) | `string` | `null` | não |
| shard_count | Número de shards (apenas para Premium) | `number` | `null` | não |
| zones | Lista de zonas de disponibilidade (apenas para Premium) | `list(string)` | `null` | não |
| redis_configuration | Configurações adicionais do Redis | `object` | `null` | não |
| firewall_rules | Regras de firewall para o Redis | `map(object)` | `{}` | não |
| patch_schedule | Agendamento de patches | `list(object)` | `[]` | não |
| tags | Tags a serem aplicadas em todos os recursos | `map(string)` | `{}` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| redis_id | ID do Redis Cache |
| redis_name | Nome do Redis Cache |
| redis_hostname | Hostname do Redis Cache |
| redis_ssl_port | Porta SSL do Redis Cache |
| redis_primary_access_key | Chave de acesso primária do Redis Cache |
| redis_secondary_access_key | Chave de acesso secundária do Redis Cache |
| redis_connection_string | String de conexão do Redis Cache |

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0.0 |
| azurerm | ~> 3.0 | 