variable "cidr_vpc" {
  description = "CIDR for our VPC"
  default     = "10.1.0.0/16"
}
variable "environment" {
  description = "Environment of the resources"
  default     = "Dev"
}
variable "cidr_public_subnet_a" {
  description = "Subnet fot the public subnet"
  default     = "10.1.0.0/24"
}
variable "cidr_public_subnet_b" { 
  description = "Subnet fot the public subnet"
  default     = "10.1.1.0/24"
}

variable "cidr_private_subnet_a" {
  description = "Subnet fot the private subnet"
  default     = "10.1.2.0/24"
}
variable "cidr_private_subnet_b" {
  description = "Subnet fot the private subnet"
  default     = "10.1.3.0/24"
}

variable "az_a" {
  description = "Availablilty zone for the subnet"
  default     = "us-east-1a"
}
variable "az_b" {
  description = "Availablilty zone for the subnet"
  default     = "us-east-1b"
}
//variable "az_c" {
  //description = "Availablilty zone for the subnet"
  //default     = "us-east-1c"
//}
//variable "az_d" {
  //description = "Availablilty zone for the subnet"
  //default     = "us-east-1d"
//}
