terraform {
  backend "s3" {
    bucket = "terraform-remote-backend-96754"
    key    = "terraform/state/terraform.tfstate"
    region = "eu-north-1"
  }
}