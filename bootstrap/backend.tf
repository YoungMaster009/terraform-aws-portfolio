terraform {
  backend "s3" {
    bucket       = "tf-state-590183753633"
    key          = "bootstrap/terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
  }
}