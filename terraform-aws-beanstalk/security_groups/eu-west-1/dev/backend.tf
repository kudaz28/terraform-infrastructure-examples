terraform {
  backend "s3" {
    region         = "eu-west-2"
    profile        = "dev"
    bucket         = "ecloud-terraform-state-dev"
    key            = "beanstalk/eu-west-1/security_groups/ENVIRONMENT/APPLICATION_NAME/terraform.tfstate"
  }
}

