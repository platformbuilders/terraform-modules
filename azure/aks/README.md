# Módulo Azure Kubernetes Service (AKS)

Este módulo Terraform cria um cluster AKS na Azure com suporte a recursos avançados, segurança e boas práticas.

## Recursos Criados

- Cluster AKS
- Node Pools (padrão e adicionais)
- Configuração de rede
- Addons (OMS, Azure Policy, etc.)
- Configuração de manutenção
- Auto Scaler

## Uso

```hcl
module "aks" {
  source = "path/to/module"

  resource_group_name = "my-resource-group"
  location           = "eastus"
  cluster_name       = "my-aks-cluster"
  
  # Configuração básica
  kubernetes_version = "1.27.7"
  dns_prefix        = "mycluster"
  sku_tier          = "Paid"
  
  # Node Pool padrão
  default_node_pool = {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2s_v3"
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
    max_pods            = 110
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    node_taints         = []
    node_labels         = {}
    zones               = ["1", "2", "3"]
    max_surge          = "33%"
  }
  
  # Node Pools adicionais
  additional_node_pools = [
    {
      name                = "userpool"
      node_count          = 1
      vm_size             = "Standard_D4s_v3"
      os_disk_size_gb     = 128
      os_disk_type        = "Managed"
      max_pods            = 110
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 3
      node_taints         = ["workload=user:NoSchedule"]
      node_labels         = { workload = "user" }
      zones               = ["1", "2", "3"]
      max_surge          = "33%"
      mode                = "User"
    }
  ]
  
  # Configuração de rede
  network_profile = {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    service_cidr       = "10.0.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
    outbound_type      = "loadBalancer"
    load_balancer_sku  = "standard"
  }
  
  # Identidade
  identity = {
    type = "SystemAssigned"
  }
  
  # Addons
  addons = {
    oms_agent                    = true
    azure_policy                 = true
    ingress_application_gateway  = false
    open_service_mesh           = false
    key_vault_secrets_provider  = false
    virtual_node                 = false
  }
  
  # Log Analytics
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  
  # Key Vault Secrets Provider
  key_vault_secrets_provider = {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
  
  # Janela de manutenção
  maintenance_window = {
    allowed = [
      {
        day   = "Sunday"
        hours = [0, 1, 2, 3, 4]
      }
    ]
    not_allowed = []
  }
  
  # Perfil do auto scaler
  auto_scaler_profile = {
    balance_similar_node_groups      = false
    max_graceful_termination_sec     = 600
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded_time         = "10m"
    scale_down_unready_time          = "20m"
    scale_down_utilization_threshold = 0.5
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
| resource_group_name | Nome do Resource Group onde o AKS será criado | `string` | n/a | sim |
| location | Região Azure onde o AKS será criado | `string` | n/a | sim |
| cluster_name | Nome do cluster AKS | `string` | n/a | sim |
| kubernetes_version | Versão do Kubernetes | `string` | `"1.27.7"` | não |
| node_resource_group | Nome do Resource Group para os nós | `string` | `null` | não |
| dns_prefix | Prefixo DNS para o cluster | `string` | `null` | não |
| private_cluster_enabled | Habilita cluster privado | `bool` | `true` | não |
| private_dns_zone_id | ID da zona DNS privada | `string` | `null` | não |
| sku_tier | Tier do cluster (Free ou Paid) | `string` | `"Free"` | não |
| default_node_pool | Configuração do node pool padrão | `object` | `{}` | não |
| additional_node_pools | Configuração dos node pools adicionais | `list(object)` | `[]` | não |
| network_profile | Configuração de rede do cluster | `object` | `{}` | não |
| identity | Configuração de identidade do cluster | `object` | `{}` | não |
| addons | Configuração dos addons do cluster | `object` | `{}` | não |
| log_analytics_workspace_id | ID do workspace do Log Analytics | `string` | `null` | não |
| application_gateway_id | ID do Application Gateway | `string` | `null` | não |
| key_vault_secrets_provider | Configuração do Key Vault Secrets Provider | `object` | `{}` | não |
| maintenance_window | Configuração da janela de manutenção | `object` | `{}` | não |
| auto_scaler_profile | Configuração do perfil do auto scaler | `object` | `{}` | não |
| tags | Tags a serem aplicadas em todos os recursos | `map(string)` | `{}` | não |

## Outputs

| Nome | Descrição |
|------|-----------|
| cluster_id | ID do cluster AKS |
| cluster_name | Nome do cluster AKS |
| cluster_identity | Identidade do cluster AKS |
| kube_config | Configuração do kubectl |
| kube_config_host | Host do cluster Kubernetes |
| kube_config_client_certificate | Certificado do cliente |
| kube_config_client_key | Chave do cliente |
| kube_config_cluster_ca_certificate | Certificado CA do cluster |
| node_pools | Informações dos node pools |
| network_profile | Perfil de rede do cluster |
| addons | Addons habilitados no cluster |

## Requisitos

| Nome | Versão |
|------|--------|
| terraform | >= 1.0.0 |
| azurerm | ~> 3.0 |
| kubernetes | ~> 2.0 |
| helm | ~> 2.0 | 