variable "infra_region" {
  type = string
  //default     = "ap-southeast-1"
  description = "This is the default region where infra will be created"
}
variable "vpc_cidr" {
  type = string
  //default     = "192.168.0.0/16"
  description = "This is default CIDR"

}
variable "no_of_resources" {
  type        = number
  default     = 6
  description = "This is to set count no of required resources"

}
variable "public_subnet_tag_name" {
  type = list(string)
  // default = ["web1", "web2"]
}
variable "private_subnet_tag_name" {
  type = list(string)
  //default = ["app1", "app2", "db1", "db2"]
}
variable "all_port" {
  type        = number
  default     = 0
  description = "all ports"
}
variable "all_protocol" {
  type        = number
  default     = -1
  description = "all protocols"

}
variable "anywhere_ip" {
  type        = string
  default     = "0.0.0.0/0"
  description = "all ip"

}
variable "ssh_port" {
  type        = number
  default     = 22
  description = "ssh port"

}
variable "tcp_protocol" {
  type        = string
  default     = "tcp"
  description = "tcp protocol"

}
variable "http_port" {
  type        = number
  default     = 80
  description = "http port"

}
variable "custom_tcp_port" {
  type        = number
  default     = 8080
  description = "8080  port"

}
variable "ipv6_address" {
  type        = string
  default     = "::/0"
  description = "all ipv6"
}

variable "ami" {
  type        = string
  default     = "ami-0af2f764c580cc1f9"
  description = "this is default ami"
}
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "default instance type"

}
variable "key_path" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/eYqzVSP0X2Am1njFOXPcaY1G+rJODwciXta9l+lkv+6Mkozmr+MM3hBI97pNG/C/Ne9ISgPvsoc78gm90F/2NqNnj5LXXXme8uKtwOg3z3TaiY93707BX7D526SdS9ekRYu6sD/dP1SeHFrJUpEEEk+Hp6opOaf4Y+oV/DDRkwm7Sd7NuLcSuYcbvpaMg2Ja+QmrKhDRw396m4DJh8lJoLJJoJK2AhgQVMsU3hkxKmgk5eHbnUFjiOF4I1XeWh2IwYLwJVA9k+cQE0lQLMGpZVymFM4CuVN0D4pR1B53VOSUuuRPe3zFXqasGj5zei78Eo3WZKX6xmW6/rkW5DSb"
  description = "public key"
}