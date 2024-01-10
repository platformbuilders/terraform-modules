resource "aws_wafv2_web_acl" "builders" {
  name        = "builders-example-web-acl"
  description = "Builders Web ACL"
  scope       = "REGIONAL" # or CLOUDFRONT for global resources

  default_action {
    allow {} #or block
  }

  rule {
    name     = "IPBlock"
    priority = 1

    action {
      allow {} #or allow
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipsetexample.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPBlock"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # Substituindo a ação para regras específicas
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            block {}
          }
          name = "NoUserAgent_HEADER"
        }

        # Restringindo o conjunto de regras para certos países
        # scope_down_statement {
        #   geo_match_statement {
        #     country_codes = ["US", "NL"]
        #   }
        # }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            block {}
          }
          name = "SignalKnownBotDataCenter"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AmazonIPReputationList"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedIPReputationList"
        }

        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedIPDDoSList"
        }

      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AmazonIPReputationList"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "builders-example-web-acl"
    sampled_requests_enabled   = true
  }
}

##Associação entre WAF e Load Balancer -- Adicionar o ARN do ALB
# resource "aws_wafv2_web_acl_association" "associaton1" {
#   resource_arn = alb arn
#   web_acl_arn  = aws_wafv2_web_acl.builders.arn
# }
