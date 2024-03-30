terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks100"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}