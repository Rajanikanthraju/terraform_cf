variable "infra_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "This is the default region where infra will be created"
}
variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "This is default CIDR"

}
variable "no_of_subnets" {
  type        = number
  default     = 16
  description = "This is to set count no of required resources"

}
variable "subnet_tag_name" {
  type        = string
  default     = "subnetfromtf"
  description = "This is the value to set the subnet name"

}