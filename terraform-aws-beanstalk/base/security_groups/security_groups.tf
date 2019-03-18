provider "aws" {
    region  = "${var.region}"
    profile = "${var.profile}"
}

module "beanstalk-security-group" {
    region                          = "${var.region}"
    profile                         = "${var.profile}"
    source                          = "git@github.com:esure-dev/inf-ter-beanstalk-security-group.git"
    name                            = "${data.terraform_remote_state.beanstalk.name}-${var.env}"
    default_security_group          = "${data.terraform_remote_state.infrastructure.default_security_group_id}"
    kong_app_security_group         = "${data.terraform_remote_state.security_groups.sg_kong_app_id}"
    windows_jump_box_security_group = "319701921293/sg-5af09420"
    linux_jump_box_security_group   = "319701921293/sg-b2da11c9"
    allow_openvpn                   = "${var.allow_openvpn}"
    openvpn_cidr_block              = "${var.openvpn_cidr_block}"
}

variable "region" {}
variable "profile" {}
variable "env" {}
variable "allow_openvpn" {}
variable "openvpn_cidr_block" {
  type = "list"
}
