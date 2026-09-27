module "network" {
  source = "./modules/network"

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
  source = "./modules/compute"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  ami_id    = "ami-02a42b4c37ec3c4b4"
  user_data = base64encode(file("${path.module}/user-data.sh"))

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