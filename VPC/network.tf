resource "aws_vpc" "vnet" {
    cidr_block = var.vpc_cidr
    tags = {
      "Name" = "vpcfromtf"
    }
}