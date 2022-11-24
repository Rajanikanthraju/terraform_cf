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
variable "no_of_resources" {
  type        = number
  default     = 2
  description = "This is to set count no of required resources"

}
variable "subnet_tag_name" {
  type        = string
  default     = "web"
  description = "This is the value to set the subnet name"

}

variable "all_port" {
    type = number
    default = 0
    description = "all ports"
  
}
variable "all_protocol" {
    type = number
    default = -1
    description = "all protocols"
  
}
variable "anywhere_ip" {
    type = string
    default = "0.0.0.0/0"
    description = "all ip"
  
}
variable "ssh_port" {
    type = number
    default = 22
    description = "ssh port"
  
}
variable "tcp_protocol" {
    type = string
    default = "tcp"
    description = "tcp protocol"
  
}
variable "http_port" {
    type = number
    default = 80
    description = "http port"
  
}
variable "custom_tcp_port" {
    type = number
    default = 8080
    description = "8080  port"
  
}
variable "ipv6_address" {
    type = string
    default = "::/0"
    description = "all ipv6"
}

variable "ami" {
    type = string
    default = "ami-0af2f764c580cc1f9"
    description = "this is default ami"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "default instance type"
  
}
variable "key_path" {
    type = string
    default = "~/.ssh/id_rsa.pub"
    description = "public key"  
}