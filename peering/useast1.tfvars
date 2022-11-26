infra_region            = "us-east-1"
vpc_cidr                = "10.1.0.0/16"
public_subnet_tag_name  = ["web1", "web2"]
private_subnet_tag_name = ["app1", "app2", "db1", "db2"]
ami                     = "ami-0b0dcb5067f052a63"