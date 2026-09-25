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