terraform {
  backend "s3" {
    region         = "eu-west-2"
    profile        = "test"
    bucket         = "ecloud-terraform-state-test"
    key            = "beanstalk/eu-west-1/environment/stsa/APPLICATION_NAME/terraform.tfstate"
  }
}

