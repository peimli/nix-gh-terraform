variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "The CIDR block for public subnet"
  type = string
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  description = "The CIDR block for private subnet"
  type = string
  default = "10.0.2.0/24"
}
variable "region" {
  description = "The AWS region"
  type = string
  default = "eu-north-1"
}
variable "az" {
  description = "The availability zone"
  type = string
  default = "eu-north-1a"
}
