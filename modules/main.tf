module "ap_southeast_vpc" {
    source = "./aws_vpc_ap_southeast-1"  
}
module "us_east_vpc" {
    source = "./aws_vpc_us_east-1"  
}

resource "aws_vpc_peering_connection" "requestor" {
  peer_vpc_id   = module.us_east_vpc.vpc_id
  vpc_id        = module.ap_southeast_vpc.vpc_id
  peer_region   = var.infra_region_acceptor
   tags = {
    Name = "VPC Peering between sing and virg"
  }
} 
resource "aws_vpc_peering_connection_accepter" "acceptor" {
provider = aws.peer
vpc_peering_connection_id = aws_vpc_peering_connection.requestor.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_route_table" "public_rt_ap_southeast" {
  vpc_id = module.ap_southeast_vpc.vpc_id

  route {
    cidr_block = var.anywhere_ip
    gateway_id = module.ap_southeast_vpc.igw_id
     }
    route {
    cidr_block = var.accptor_cidr_range
    vpc_peering_connection_id = aws_vpc_peering_connection.requestor.id
    }
     
  tags = {
    Name = "public_rt_root"
  }
  
}
resource "aws_route_table" "public_rt_us_east" {
  provider = aws.peer
  vpc_id = module.us_east_vpc.vpc_id

  route {
    cidr_block = var.anywhere_ip
    gateway_id = module.us_east_vpc.igw_id
    }
    route {
    cidr_block = var.requestor_cidr_range
    vpc_peering_connection_id = aws_vpc_peering_connection.requestor.id
    }
  tags = {
    Name = "public_rt_root"
  }
  
}
resource "aws_route_table_association" "root_private_association" {
  count=length(module.ap_southeast_vpc.private_subnet_ids)
  subnet_id   =module.ap_southeast_vpc.private_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt_ap_southeast.id
depends_on = [
  aws_route_table_association.root_public_association
]
}
resource "aws_route_table_association" "us_root_private_association" {
  provider = aws.peer
  count=length(module.us_east_vpc.private_subnet_ids)
  subnet_id   =module.us_east_vpc.private_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt_us_east.id
  depends_on = [
    aws_route_table_association.us_root_public_association
  ]
}
  
