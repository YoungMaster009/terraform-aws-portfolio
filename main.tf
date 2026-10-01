module "network" {
  source      = "./modules/network"
  name_prefix = "dev"

  vpc_cidr       = "10.32.0.0/16"
  nat_subnet_key = "public-us-west-1a"

  subnets = {
    "public-us-west-1a" = {
      cidr   = "10.32.1.0/24"
      az     = "us-west-1a"
      public = true
    }
    "public-us-west-1c" = {
      cidr   = "10.32.3.0/24"
      az     = "us-west-1c"
      public = true
    }
    "private-us-west-1a" = {
      cidr   = "10.32.11.0/24"
      az     = "us-west-1a"
      public = false
    }
    "private-us-west-1c" = {
      cidr   = "10.32.13.0/24"
      az     = "us-west-1c"
      public = false
    }
  }

  tags = {
    Service = "application1"
    Owner   = "Luke"
    Planet  = "Mustafar"
  }
}
module "compute" {
  source      = "./modules/compute"
  name_prefix = "dev"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  ami_id = "ami-02a42b4c37ec3c4b4"

  instance_profile_name = aws_iam_instance_profile.instance.name
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    assets_bucket = aws_s3_bucket.assets.id
  }))
  certificate_arn = aws_acm_certificate_validation.site.certificate_arn
  tags = {
    Service = "application1"
    Owner   = "Luke"
    Planet  = "Mustafar"
  }
}

output "lb_dns_name" {
  value       = module.compute.alb_dns_name
  description = "The DNS name of the App1 load balancer"
}