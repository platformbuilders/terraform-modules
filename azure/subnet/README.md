# Módulo Azure Subnet

Este módulo Terraform cria subnets públicas e privadas na Azure, similar ao padrão AWS VPC. O módulo inclui suporte a NAT Gateway para subnets privadas e Network Security Groups (NSGs).

## Recursos Criados

- Subnets públicas e privadas
- Network Security Groups (NSGs)
- NAT Gateway para subnets privadas
- Route Tables para subnets privadas
- Associações entre Subnets e NSGs

## Uso

```hcl
module "subnet" {
  source = "path/to/module"

  resource_group_name = "my-resource-group"
  location           = "eastus"
  vnet_name          = "my-vnet"
  availability_zones = ["1", "2", "3"]

  public_subnets = {
    public1 = {
      name       = "public-subnet-1"
      cidr_block = "10.0.1.0/24"
      az_index   = 0
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
      nsg_rules = [
        {
          name                       = "allow-ssh"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  }

  private_subnets = {
    private1 = {
      name       = "private-subnet-1"
      cidr_block = "10.0.2.0/24"
      az_index   = 0
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
      nsg_rules = [
        {
          name                       = "allow-internal"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "10.0.0.0/16"
          destination_address_prefix = "*"
        }
      ]
    }
  }

  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| resource_group_name | Nome do Resource Group onde a subnet será criada | `string` | n/a | sim |
| location | Região Azure onde os recursos serão criados | `string` | n/a | sim |
| vnet_name | Nome da Virtual Network onde a subnet será criada | `string` | n/a | sim |
| availability_zones | Lista de Availability Zones disponíveis na região | `list(string)` | n/a | sim |
| public_subnets | Mapa de subnets públicas a serem criadas | `map(object)` | `{}` | não |
| private_subnets | Mapa de subnets privadas a serem criadas | `map(object)` | `{}` | não |
| tags | Tags a serem aplicadas em todos os recursos | `map(string)` | `{}` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| subnet_ids | Map de IDs de todas as subnets criadas |
| nsg_ids | Map de IDs dos Network Security Groups criados |
| nat_gateway_id | ID do NAT Gateway criado para as subnets privadas |
| nat_gateway_public_ip | Endereço IP público do NAT Gateway |
| private_route_table_id | ID da Route Table criada para as subnets privadas |
| public_subnet_ids | Map de IDs das subnets públicas |
| private_subnet_ids | Map de IDs das subnets privadas |

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0.0 |
| azurerm | ~> 3.0 | 