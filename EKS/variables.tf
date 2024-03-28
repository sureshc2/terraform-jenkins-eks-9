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
