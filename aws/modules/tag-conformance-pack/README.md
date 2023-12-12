# Overview
TagConformancePack is a Terraform project designed to deploy an AWS Conformance Pack. 
It leverages AWS Config to enforce compliance with certain tagging standards across AWS resources. 
This project integrates AWS Managed Config Rules, custom AWS Lambda functions, and AWS EventBridge for automated 
compliance checks and actions.

## Project Structure

```
.
└── module/
    └── tag-conformance-pack/
        ├── conformance-pack.tf
        ├── custom_lambda_config
        ├── data.tf
        ├── iam.tf
        ├── lambda_event_bridge_tagger.tf
        ├── locals.tf
        ├── outputs.tf
        ├── s3.tf
        ├── ssm.tf
        ├── variables.tf
        └── versions.tf
```

## TagConformacePack

### Conformance pack


#### config required-tags

recurssos suportados

script

diagram

#### custom lambda config

recurssos suportados

script

diagram

#### Event Bridge tagger

recurssos suportados

script

diagram

*cloud trail*

#### iam permissions

## Debug

#### Tag conformance pack
O ssm document pode ter seus logs de execução observados em ssm > automations.

1. Erro de catálogo. O erro abaixo indica que falta informação no catálogo para o recurso em questão.
```shell
# fix erro ssm automation - update de tags no catalogo
application_value = matching_item.get("application", "")
```
2. Erro de acesso

3. Erro na ação de tagueamento de recurso espećifico

4. Erro ao tentar coletar as tags do recurso