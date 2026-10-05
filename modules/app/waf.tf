variable "enable_waf" {
  description = "Attach a WAF to the ALB. Off by default: a Web ACL bills $5/mo plus $1 per rule."
  type        = bool
  default     = false
}

resource "aws_wafv2_web_acl" "app1_waf_acl" {
  count       = var.enable_waf ? 1 : 0
  name        = "${var.name_prefix}-app1-web-acl"
  description = "Web ACL for app1"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "IPBlockRule"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_block_list[0].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "IPBlockRule"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputs"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesKnownBadInputs"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.name_prefix}-app1WebACL"
    sampled_requests_enabled   = false
  }

  tags = {
    Name    = "${var.name_prefix}-app1-web-acl"
    Service = "application1"
    Owner   = "Chewbacca"
    
  }
}

resource "aws_wafv2_ip_set" "ip_block_list" {
  count              = var.enable_waf ? 1 : 0
  name               = "${var.name_prefix}-ip-block-list"
  description        = "List of blocked IP addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "1.188.0.0/16",
    "1.80.0.0/16",
    "101.144.0.0/16",
    "101.16.0.0/16"
  ]

  tags = {
    Name    = "${var.name_prefix}-ip-block-list"
    Service = "application1"
    Owner   = "Chewbacca"
    
  }
}

resource "aws_wafv2_web_acl_association" "app1_waf_alb_association" {
  count        = var.enable_waf ? 1 : 0
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.app1_waf_acl[0].arn
}

# Other AWS managed rule groups you could add:
# AWSManagedRulesAmazonIpReputationList
# AWSManagedRulesAnonymousIpList
# AWSManagedRulesCommonRuleSet
# AWSManagedRulesLinuxRuleSet