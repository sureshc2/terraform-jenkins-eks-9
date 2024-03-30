terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks1000"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}