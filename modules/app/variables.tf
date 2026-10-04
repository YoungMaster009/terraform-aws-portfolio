variable "name_prefix" {
  description = "Prefix for resource names, e.g. dev or prod"
  type        = string
}

variable "zone_name" {
  description = "Route 53 hosted zone (the apex domain)"
  type        = string
}

variable "site_domain" {
  description = "Address this environment serves, used for the cert and DNS record"
  type        = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "alb_arn" {
  type = string
}