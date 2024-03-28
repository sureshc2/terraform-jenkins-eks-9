variable "aws_region" {
  default = "us-east-1"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}
variable "avail-zone" {
  type = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1f"]
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
  type    = string
}

variable "public_subnets" {
  default = ["192.168.0.0/16"]
  type    = list
}

variable "private_subnets" {
  default = ["192.168.0.0/16"]
  type    = list
}


