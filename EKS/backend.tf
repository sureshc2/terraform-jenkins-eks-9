terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks9"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}