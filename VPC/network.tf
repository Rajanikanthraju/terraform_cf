
#Creating VPC in Singapore region
resource "aws_vpc" "vnet" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "vpcfromtf"
  }
}

#create 2 puvlic subnets for web servers
resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vnet.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = format("${var.infra_region}%s", count.index % 2 == 0 ? "a" : "b")
  tags = {
    "Name" = var.public_subnet_tag_name[count.index]
  }
  depends_on = [
    aws_vpc.vnet
  ]

}
#create 4 private subnets for app servers & DB servers
resource "aws_subnet" "private_subnet" {
  count             = 4
  vpc_id            = aws_vpc.vnet.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index+2)
  availability_zone = format("${var.infra_region}%s", count.index % 2 == 0 ? "a" : "b")
  tags = {
    "Name" = var.private_subnet_tag_name[count.index]
  }
  depends_on = [
    aws_vpc.vnet
  ]

}

#creation of web server security group
resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.vnet.id
  description = "allow traffic as specified"
  ingress {
    to_port     = var.all_port
    from_port   = var.all_port
    protocol    = var.all_protocol
    cidr_blocks = [var.vpc_cidr]
    description = "allow all traffic within VPC"
  }
  ingress {
    to_port     = var.http_port
    from_port   = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.anywhere_ip]
    description = "allow traffic on port 80 from anywhere"
  }
  ingress {
    to_port     = var.custom_tcp_port
    from_port   = var.custom_tcp_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.anywhere_ip]
    description = "allow traffic on port 8080 from anywhere"
  }
  ingress {
    to_port     = var.ssh_port
    from_port   = var.ssh_port
    protocol    = var.tcp_protocol
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

#creation of app server security group
resource "aws_security_group" "asg" {
  vpc_id      = aws_vpc.vnet.id
  description = "allow traffic as specified"
   ingress {
    to_port     = var.ssh_port
    from_port   = var.ssh_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.vpc_cidr]
    description = "allow traffic on port 22 from anywhere"
  }
  ingress {
    to_port     = var.all_port
    from_port   = var.all_port
    protocol    = var.all_protocol
    cidr_blocks = [var.vpc_cidr]
    description = "allow all traffic within VPC"
  }

  egress {
    from_port        = var.all_port
    to_port          = var.all_port
    protocol         = var.all_protocol
    cidr_blocks      = [var.anywhere_ip]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "asgfromtf"
  }
  depends_on = [
    aws_vpc.vnet
  ]
}


#creating Internet gateway for internet 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vnet.id

  tags = {
    Name = "igw"
  }
  depends_on = [
    aws_vpc.vnet
  ]
}

resource "aws_eip" "lb" {
  vpc = true
  tags = {
    "Name" = "eipfromtf"
  }
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.lb.id
  subnet_id = aws_subnet.public_subnet[0].id
  tags = {
    "Name" = "ngwfromtf"
  }
  depends_on = [
    aws_eip.lb
  ]
}

#creation of public route table and attach to Internet gateway
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
#creation of private route table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vnet.id
 route {
    cidr_block = var.anywhere_ip
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "private_rt"
  }
  depends_on = [
    aws_vpc.vnet
  ]
}

#Route table association
resource "aws_route_table_association" "publicigw" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_key_pair" "key" {
  key_name   = "publickey"
  public_key = var.key_path

}

#creating Web server in public subnet
resource "aws_instance" "ec2instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.public_subnet[0].id
  key_name                    = aws_key_pair.key.key_name
  tags = {
    "Name" = "amazonec2"
  }
  provisioner "file" {
  source      = "~/Downloads/awsclipractice.pem"
  destination = "awsclipractice.pem"

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/Downloads/awsclipractice.pem")
    host     = self.public_ip
  }
}
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/Downloads/awsclipractice.pem")
    host     = self.public_ip
  }
provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 awsclipractice.pem"
    ]
  }
  depends_on = [
    aws_subnet.public_subnet,
    aws_security_group.sg,
    aws_key_pair.key
  ]
}
#creating app server in private  subnet 
resource "aws_instance" "privateec2instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.asg.id]
  subnet_id                   = aws_subnet.private_subnet[0].id
  key_name                    = aws_key_pair.key.key_name
  tags = {
    "Name" = "privateamazonec2"
  }
  depends_on = [
    aws_subnet.private_subnet,
    aws_security_group.asg,
    aws_key_pair.key
  ]
}


output "publicserverip" {
  value = aws_instance.ec2instance.public_ip
  
}
output "privateserverip" {
  value= aws_instance.privateec2instance.private_ip
}
