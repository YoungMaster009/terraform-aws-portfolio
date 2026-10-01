variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    cidr   = string
    az     = string
    public = bool
  }))
}

variable "nat_subnet_key" {
  description = "Key of the public subnet that hosts the NAT gateway"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Environment prefix for resource names, e.g. dev or prod"
  type        = string
}