# Módulo Azure Application Gateway

Este módulo Terraform permite criar e gerenciar um Azure Application Gateway com configurações personalizáveis.

## Recursos Suportados

- Application Gateway v2
- Configuração de SKU e capacidade
- Frontend IP configurations
- Backend address pools
- HTTP settings
- HTTP listeners
- Request routing rules
- Health probes
- SSL/TLS termination (opcional)

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0.0 |

## Uso

```hcl
module "application_gateway" {
  source = "path/to/module"

  app_gateway_name    = "appgw-example"
  resource_group_name = "rg-example"
  location            = "Brazil South"
  subnet_id           = "subnet-id"

  frontend_ip_configurations = [
    {
      name                 = "frontend-ip-config"
      public_ip_address_id = "public-ip-id"
    }
  ]

  backend_address_pools = [
    {
      name         = "backend-pool"
      ip_addresses = ["10.0.2.4", "10.0.2.5"]
    }
  ]

  backend_http_settings = [
    {
      name                  = "http-settings"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 60
      probe_name           = "health-probe"
    }
  ]

  http_listeners = [
    {
      name                           = "http-listener"
      frontend_ip_configuration_name = "frontend-ip-config"
      frontend_port_name            = "port_80"
      protocol                      = "Http"
    }
  ]

  request_routing_rules = [
    {
      name                       = "routing-rule"
      rule_type                 = "Basic"
      http_listener_name        = "http-listener"
      backend_address_pool_name = "backend-pool"
      backend_http_settings_name = "http-settings"
    }
  ]

  probes = [
    {
      name                = "health-probe"
      protocol            = "Http"
      path                = "/"
      host                = "example.com"
      interval            = 30
      timeout             = 30
      unhealthy_threshold = 3
    }
  ]

  tags = {
    Environment = "Production"
    Project     = "Application Gateway"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| app_gateway_name | Nome do Application Gateway | `string` | n/a | sim |
| resource_group_name | Nome do Resource Group | `string` | n/a | sim |
| location | Localização do recurso | `string` | n/a | sim |
| sku_name | Nome do SKU do Application Gateway | `string` | `"Standard_v2"` | não |
| sku_tier | Tier do SKU do Application Gateway | `string` | `"Standard_v2"` | não |
| capacity | Capacidade do Application Gateway | `number` | `2` | não |
| subnet_id | ID da subnet onde o Application Gateway será implantado | `string` | n/a | sim |
| frontend_ports | Lista de portas frontend | `list(object)` | `[{name = "port_80", port = 80}]` | não |
| frontend_ip_configurations | Lista de configurações de IP frontend | `list(object)` | n/a | sim |
| backend_address_pools | Lista de pools de endereços backend | `list(object)` | n/a | sim |
| backend_http_settings | Lista de configurações HTTP backend | `list(object)` | n/a | sim |
| http_listeners | Lista de listeners HTTP | `list(object)` | n/a | sim |
| request_routing_rules | Lista de regras de roteamento | `list(object)` | n/a | sim |
| probes | Lista de probes de saúde | `list(object)` | n/a | sim |
| tags | Tags para os recursos | `map(string)` | `{}` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| id | ID do Application Gateway |
| name | Nome do Application Gateway |
| private_ip_address | Endereço IP privado do Application Gateway |
| public_ip_address | Endereço IP público do Application Gateway |
| backend_address_pools | Pools de endereços backend configurados |
| backend_http_settings | Configurações HTTP backend configuradas |
| http_listeners | Listeners HTTP configurados |
| request_routing_rules | Regras de roteamento configuradas |

## Segurança

Este módulo implementa as seguintes práticas de segurança:

1. Uso de SKU Standard_v2 que suporta WAF (Web Application Firewall)
2. Configuração de health probes para monitoramento de saúde
3. Suporte a SSL/TLS termination
4. Configuração de timeouts e thresholds para proteção contra ataques

## Contribuição

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'feat: add some amazing feature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes. 