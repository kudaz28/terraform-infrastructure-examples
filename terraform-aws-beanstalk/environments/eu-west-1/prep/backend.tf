terraform {
  backend "s3" {
    region         = "eu-west-2"
    profile        = "prep"
    bucket         = "ecloud-terraform-state-prep"
    key            = "beanstalk/eu-west-1/environment/ENVIRONMENT/APPLICATION_NAME/terraform.tfstate"
  }
}

