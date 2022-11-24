variable "infra_region" {
    type = string
    default = "ap-southeast-1"
    description = "This is the default region where infra will be created"
}
variable "vpc_cidr" {
    type=string
    default = "192.168.0.0/16"
    description = "This is default CIDR"
  
}