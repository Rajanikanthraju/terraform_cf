
#Creating VPC in Singapore region
resource "aws_vpc" "vnet" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "vpcfromtf"
  }
}

#create 16 subnets each should accompany 500 hosts ipv4 addresses
resource "aws_subnet" "subnet" {
  count             = var.no_of_subnets
  vpc_id            = aws_vpc.vnet.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 7, count.index)
  availability_zone = format("${var.infra_region}%s", count.index % 2 == 0 ? "a" : "b")
  tags = {
    "Name" = format("${var.subnet_tag_name}%d", count.index + 1)
  }

  depends_on = [
    aws_vpc.vnet
  ]

}

