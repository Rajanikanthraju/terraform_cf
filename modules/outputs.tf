output "ap_southeast_vpc_id" {
    value = module.ap_southeast_vpc.vpc_id
}
output "us_east_vpc_id" {
    value = module.us_east_vpc.vpc_id  
}
output "peering_connection_id" {
    value = aws_vpc_peering_connection.requestor.id
  
}