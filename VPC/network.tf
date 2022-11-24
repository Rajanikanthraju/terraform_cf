
#Creating VPC in Singapore region
resource "aws_vpc" "vnet" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "vpcfromtf"
  }
}

#create 16 subnets each should accompany 500 hosts ipv4 addresses
resource "aws_subnet" "subnet" {
  count             = var.no_of_resources
  vpc_id            = aws_vpc.vnet.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = format("${var.infra_region}%s", count.index % 2 == 0 ? "a" : "b")
  tags = {
    "Name" = format("${var.subnet_tag_name}%d", count.index + 1)
  }

  depends_on = [
    aws_vpc.vnet
  ]

}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vnet.id
  description = "allow traffic as specified"
  ingress  {
    to_port = var.all_port
    from_port = var.all_port
    protocol = var.all_protocol
    cidr_blocks = [ var.vpc_cidr]
    description = "allow all traffic within VPC"  
    }
    ingress  {
    to_port = var.http_port
    from_port = var.http_port
    protocol = var.tcp_protocol
    cidr_blocks = [var.anywhere_ip]
    description = "allow traffic on port 80 from anywhere"  
    }
    ingress  {
    to_port = var.custom_tcp_port
    from_port = var.custom_tcp_port
    protocol = var.tcp_protocol
    cidr_blocks = [var.anywhere_ip]
    description = "allow traffic on port 8080 from anywhere"  
    }
    ingress  {
    to_port = var.ssh_port
    from_port = var.ssh_port
    protocol = var.tcp_protocol
    cidr_blocks = [var.anywhere_ip]
    description = "allow traffic on port 22 from anywhere"  
    }

    egress {
    from_port        = var.all_port
    to_port          = var.all_port
    protocol         = var.all_protocol
    cidr_blocks      = [var.anywhere_ip]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    "Name" = "sgfromtf"
  }
  depends_on = [
    aws_vpc.vnet
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vnet.id

  tags = {
    Name = "igw"
  }
  depends_on = [
    aws_vpc.vnet
  ]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vnet.id

route {
    cidr_block = var.anywhere_ip
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_rt"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}
resource "aws_route_table_association" "publicigw" {
   count = var.no_of_resources
  subnet_id = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}  

resource "aws_key_pair" "key" {
  key_name = "publickey"
  public_key = file(var.key_path)
  
}

resource "aws_instance" "ec2instance"{
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.subnet[0].id
  key_name = aws_key_pair.key.key_name
  tags = {
    "Name" = "amazonec2"
  }
depends_on = [
  aws_subnet.subnet,
  aws_security_group.sg,
  aws_key_pair.key
]
}  
