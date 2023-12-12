
# AmazonMQ

Gerenciar tabelas e views do Big Query no GCP, seguindo padrões de construção e de segurança da Builders.

## Uso

Exemplo de uso deste modulo:

```terraform
module "mq" {
  source = "github.com/platformbuilders/terraform-modules//aws/modules/aws_mq"

  name     = var.name
  username = "admin"
  password = "supersenhadoadmin"

  vpc_id     = module.vpc.id
  subnet_ids = module.subnet.private-ids
}
```
