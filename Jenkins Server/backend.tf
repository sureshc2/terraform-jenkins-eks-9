terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks99"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}