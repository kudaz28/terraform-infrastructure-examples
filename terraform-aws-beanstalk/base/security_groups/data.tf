data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config {
    bucket  = "ecloud-terraform-state-${var.profile}"
    region  = "eu-west-2"
    profile = "${var.profile}"
    key     = "vpc/${var.region}/${var.profile}/terraform.tfstate"
  }
}

data "terraform_remote_state" "beanstalk" {
  backend = "s3"
  config {
    region  = "eu-west-2"
    profile = "${var.profile}"
    bucket  = "ecloud-terraform-state-${var.profile}"
    key     = "beanstalk/${var.region}/application/APPLICATION_NAME/terraform.tfstate"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config {
    bucket  = "ecloud-terraform-state-${var.profile}"
    region  = "eu-west-2"
    profile = "${var.profile}"
    key     = "aws_security_groups/${var.region}/${var.env}/ops-kong/terraform.tfstate"
  }
}

