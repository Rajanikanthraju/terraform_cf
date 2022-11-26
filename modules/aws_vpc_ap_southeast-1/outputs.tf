output "server_public_ip" {
      value = "ssh -i  ec2-user@${aws_instance.ec2instance.public_ip}"

}
output "server_private_ip" {
    value = aws_instance.ec2instance.private_ip
  
}
output "vpc_id" {
    value = aws_vpc.vnet.id
  
}
output "igw_id" {
    value = aws_internet_gateway.igw.id
  
}
output "pulic_subnet_ids" {
    value = aws_subnet.public_subnet.id
  
}
output "private_subnet_ids" {
        value = aws_subnet.private_subnet[*].id
  
}