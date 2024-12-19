data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_name    = "eks-${var.name}"
  cluster_version = var.eks_version

  cluster_endpoint_private_access = var.endpoint_private_access
  cluster_endpoint_public_access  = var.endpoint_public_access
  kms_key_administrators          = var.kms_key_administrators

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = var.ebs_service_account_role
    }
  }

  cluster_security_group_additional_rules = {
    ingress_vpn = {
      description                   = "Access EKS from Builders VPN"
      type                          = "ingress"
      from_port                     = 0
      to_port                       = 65535
      protocol                      = "tcp"
      cidr_blocks                   = ["10.30.0.0/16"]
      source_cluster_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_all_trafic_eks_api = {
      description                   = "Access EKS from EKS API"
      type                          = "ingress"
      from_port                     = 0
      to_port                       = 65535
      protocol                      = "tcp"
      security_group_id             = module.eks.cluster_security_group_id
      source_cluster_security_group = true
    }
  }

  # cluster_encryption_config = [{
  #   provider_key_arn = aws_kms_key.secret_encrypt.arn
  #   resources        = ["secrets"]
  # }]

  vpc_id     = var.vpc_id
  subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)

  eks_managed_node_group_defaults = {
    disk_size                    = var.disk_size_gb
    instance_types               = var.instance_type
    iam_role_additional_policies = {}
  }

  eks_managed_node_groups = {
    for name, config in var.eks_node_groups : name => {
      min_size                   = config.min_size
      max_size                   = config.max_size
      desired_size               = config.desired_size
      instance_types             = config.instance_types
      subnet_ids                 = concat(var.private_subnet_ids, var.public_subnet_ids)
      use_custom_launch_template = config.use_custom_launch_template
      disk_size                  = config.disk_size
      iam_role_additional_policies = {
        managed_policy_arns = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  manage_aws_auth_configmap = var.manage_aws_auth_configmap

  aws_auth_roles = var.additional_roles

  aws_auth_users = []
}
