provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "beanstalk" {
  source                = "git@github.com:esure-dev/inf-ter-beanstalk-application.git?ref=v1.0"
  name                  = "APPLICATION_NAME"
  max_count             = "${var.max_count}"
  delete_source_from_s3 = "${var.delete_source_from_s3}"
}

variable "region" {}
variable "profile" {}
variable "max_count" {
  description = "max number of labesl to keep"
  default     = 5
}
variable "delete_source_from_s3" {
  description = "delete code from s3 bucket"
  default     = true
}

