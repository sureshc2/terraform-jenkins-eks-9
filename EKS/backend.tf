terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks99"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}