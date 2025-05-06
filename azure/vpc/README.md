# Módulo Azure VPC

Este módulo Terraform cria uma Virtual Network (VPC) na Azure, seguindo o padrão AWS VPC. O módulo inclui suporte a DNS, Flow Logs e múltiplos blocos CIDR.

## Recursos Criados

- Virtual Network (VNet)
- Zona DNS Privada (opcional)
- Flow Logs (opcional)
  - Storage Account para logs
  - Log Analytics Workspace
  - Network Watcher Flow Log

## Uso

```hcl
module "vpc" {
  source = "path/to/module"

  resource_group_name = "my-resource-group"
  location           = "eastus"
  vnet_name          = "my-vnet"
  cidr_block         = "10.0.0.0/16"
  
  secondary_cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  enable_flow_log = true
  flow_log_retention_in_days = 30
  flow_log_traffic_type     = "ALL"

  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| resource_group_name | Nome do Resource Group onde a VPC será criada | `string` | n/a | sim |
| location | Região Azure onde os recursos serão criados | `string` | n/a | sim |
| vnet_name | Nome da Virtual Network | `string` | n/a | sim |
| cidr_block | Espaço de endereçamento principal da VPC (CIDR) | `string` | `"10.0.0.0/16"` | não |
| secondary_cidr_blocks | Lista de blocos CIDR secundários para a VPC | `list(string)` | `[]` | não |
| enable_dns_hostnames | Habilita suporte a DNS hostnames na VPC | `bool` | `true` | não |
| enable_dns_support | Habilita suporte a DNS na VPC | `bool` | `true` | não |
| enable_flow_log | Habilita Flow Logs para a VPC | `bool` | `false` | não |
| flow_log_retention_in_days | Número de dias para retenção dos Flow Logs | `number` | `30` | não |
| flow_log_traffic_type | Tipo de tráfego a ser registrado nos Flow Logs | `string` | `"ALL"` | não |
| tags | Tags a serem aplicadas em todos os recursos | `map(string)` | `{}` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| vnet_id | ID da Virtual Network criada |
| vnet_name | Nome da Virtual Network criada |
| vnet_cidr_block | CIDR block principal da VPC |
| vnet_secondary_cidr_blocks | Lista de CIDR blocks secundários da VPC |
| private_dns_zone_id | ID da zona DNS privada criada |
| private_dns_zone_name | Nome da zona DNS privada criada |
| flow_log_storage_account_id | ID da conta de armazenamento dos Flow Logs |
| flow_log_workspace_id | ID do workspace do Log Analytics para Flow Logs |

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0.0 |
| azurerm | ~> 3.0 | 