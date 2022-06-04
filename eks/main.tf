provider "aws" {
    region = "ap-south-1"
}

data "aws_availability_zones" "azs" {}

module "vpc"  {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "demo-vpc"
  cidr = var.cidr
  private_subnets = var.private_subnets_cidr_blocks
  public_subnets = var.public_subnets_cidr_blocks  
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

 tags = {
     "kubernetes.io/cluster/demo-els-cluster" = "shared"
 }

 public_subnet_tags = {
     "kubernetes.io/cluster/demo-els-cluster" = "shared"
     "kubernetes.io/role/elb" = 1
 }
  
 private_subnet_tags = {
     "kubernetes.io/cluster/demo-els-cluster" = "shared"
      "kubernetes.io/role/internal-elb" = 1
 }


}