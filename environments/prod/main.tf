module "network" {
  source      = "../../modules/network"
  name_prefix = "prod"

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


}
module "compute" {
  source      = "../../modules/compute"
  name_prefix = "prod"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  ami_id = "ami-02a42b4c37ec3c4b4"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  instance_profile_name = module.app.instance_profile_name
  user_data = base64encode(templatefile("${path.module}/../../user-data.sh", {
    assets_bucket = module.app.assets_bucket
  }))
  certificate_arn = module.app.certificate_arn

}

module "app" {
  source      = "../../modules/app"
  name_prefix = "prod"

  zone_name   = "doiwannaknowthediaryofjane.com"
  site_domain = "doiwannaknowthediaryofjane.com"

  alb_dns_name = module.compute.alb_dns_name
  alb_zone_id  = module.compute.alb_zone_id
  alb_arn      = module.compute.alb_arn

  enable_waf = false
}
output "lb_dns_name" {
  value       = module.compute.alb_dns_name
  description = "The DNS name of the App1 load balancer"
}