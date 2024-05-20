## Get SHA1 fingerprint
data "tls_certificate" "oidc_root_ca" {
  url = var.cluster_oidc_issuer
}


## OIDC provider
resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_root_ca.certificates[0].sha1_fingerprint]
  url             = var.cluster_oidc_issuer
} 