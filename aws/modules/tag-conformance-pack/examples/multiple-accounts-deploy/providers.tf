provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      git-location = "https://gitlab.com/raiadrogasil/rd/devops-rd/finopstools/tagconformacepack"
      application  = var.tags["application"]
      domain       = var.tags["domain"]
      board        = var.tags["board"]
      company      = var.tags["company"]
      shared       = var.tags["shared"]
      env          = var.tags["env"]
      tag_created  = var.tags["tag_created"]
    }
  }
}

