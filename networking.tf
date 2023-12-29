#vpc module
module "vpc" {
  source   = "./vpc/"
  vpc_cidr = "10.0.0.0/20"
}