variable "infra_region_requestor" {
  type = string
  default     = "ap-southeast-1"
  description = "This is the default region where infra will be created"
}
variable "infra_region_acceptor" {
  type = string
  default     = "us-east-1"
  description = "This is the default region where infra will be created"
}
variable "anywhere_ip" {
  type = string
  default = "0.0.0.0/0"  
}
variable "requestor_cidr_range" {
  type = string
  default = "10.0.0.0/16"  
}
variable "accptor_cidr_range" {
  type = string
  default = "10.1.0.0/16"  
}