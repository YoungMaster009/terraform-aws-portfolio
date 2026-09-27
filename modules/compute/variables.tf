variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "user_data" {
  description = "Base64-encoded startup script"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "CIDR ranges allowed to reach SSH"
  type        = list(string)
  default     = []
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}