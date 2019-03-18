terraform {
  backend "s3" {
    region  = "${var.region}"
    profile = "${var.profile}"
  }
}

