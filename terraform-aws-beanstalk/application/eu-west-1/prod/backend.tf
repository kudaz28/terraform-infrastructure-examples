terraform {
  backend "s3" {
    region         = "eu-west-2"
    profile        = "prod"
    bucket         = "ecloud-terraform-state-prod"
    key            = "beanstalk/eu-west-1/application/APPLICATION_NAME/terraform.tfstate"
  }
}

