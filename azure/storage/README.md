# Módulo Azure Storage Account

Este módulo Terraform cria uma Storage Account na Azure com suporte a diferentes tipos de armazenamento, configurações de segurança e regras de lifecycle.

## Recursos Criados

- Storage Account
- Containers (opcional)
- Filas (opcional)
- Tabelas (opcional)
- File Shares (opcional)
- Regras de Lifecycle (opcional)

## Uso

```hcl
module "storage" {
  source = "path/to/module"

  resource_group_name = "my-resource-group"
  location           = "eastus"
  storage_account_name = "mystorageaccount"
  
  # Configuração básica
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  
  # Configurações de segurança
  enable_https_traffic_only = true
  min_tls_version         = "TLS1_2"
  allow_blob_public_access = false
  
  # Regras de rede
  network_rules = {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = ["10.0.0.0/24"]
    virtual_network_subnet_ids = [module.subnet.private_subnet_ids["private1"]]
  }
  
  # Containers
  containers = [
    {
      name        = "container1"
      access_type = "private"
    },
    {
      name        = "container2"
      access_type = "blob"
    }
  ]
  
  # Filas
  queues = ["queue1", "queue2"]
  
  # Tabelas
  tables = ["table1", "table2"]
  
  # File Shares
  file_shares = [
    {
      name             = "share1"
      quota_in_gb      = 100
      access_tier      = "Hot"
      enabled_protocol = "SMB"
    }
  ]
  
  # Regras de Lifecycle
  lifecycle_rules = [
    {
      name      = "rule1"
      enabled   = true
      prefix    = "logs/"
      tier_to_cool_after_days    = 30
      tier_to_archive_after_days = 90
      delete_after_days          = 365
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
| resource_group_name | Nome do Resource Group onde a Storage Account será criada | `string` | n/a | sim |
| location | Região Azure onde a Storage Account será criada | `string` | n/a | sim |
| storage_account_name | Nome da Storage Account | `string` | n/a | sim |
| account_tier | Tier da Storage Account (Standard ou Premium) | `string` | `"Standard"` | não |
| account_replication_type | Tipo de replicação (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS) | `string` | `"LRS"` | não |
| access_tier | Tier de acesso (Hot ou Cool) | `string` | `"Hot"` | não |
| enable_https_traffic_only | Força o uso de HTTPS para todas as operações | `bool` | `true` | não |
| min_tls_version | Versão mínima do TLS (TLS1_0, TLS1_1, TLS1_2) | `string` | `"TLS1_2"` | não |
| allow_blob_public_access | Permite acesso público aos blobs | `bool` | `false` | não |
| network_rules | Regras de rede para a Storage Account | `object` | `{}` | não |
| containers | Lista de containers a serem criados | `list(object)` | `[]` | não |
| queues | Lista de filas a serem criadas | `list(string)` | `[]` | não |
| tables | Lista de tabelas a serem criadas | `list(string)` | `[]` | não |
| file_shares | Lista de file shares a serem criados | `list(object)` | `[]` | não |
| lifecycle_rules | Regras de lifecycle para os blobs | `list(object)` | `[]` | não |
| tags | Tags a serem aplicadas em todos os recursos | `map(string)` | `{}` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| storage_account_id | ID da Storage Account |
| storage_account_name | Nome da Storage Account |
| primary_blob_endpoint | Endpoint primário para blobs |
| primary_queue_endpoint | Endpoint primário para filas |
| primary_table_endpoint | Endpoint primário para tabelas |
| primary_file_endpoint | Endpoint primário para arquivos |
| primary_access_key | Chave de acesso primária |
| secondary_access_key | Chave de acesso secundária |
| container_ids | IDs dos containers criados |
| queue_ids | IDs das filas criadas |
| table_ids | IDs das tabelas criadas |
| file_share_ids | IDs dos file shares criados |

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0.0 |
| azurerm | ~> 3.0 | 