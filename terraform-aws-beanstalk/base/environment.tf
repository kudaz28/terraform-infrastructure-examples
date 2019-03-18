provider "aws" {
    region  = "${var.region}"
    profile = "${var.profile}"
}

data "aws_caller_identity" "current" {}

locals {
  elb_subnets = "${var.environment == "stsa" || var.environment == "stsb" || var.environment == "pcya" ? data.terraform_remote_state.infrastructure.ilb_subnets2 : data.terraform_remote_state.infrastructure.ilb_subnets }"
}

resource "random_string" "password" {
    length  = 32
    special = false
    lower   = true
    upper   = false
    number  = true
}

resource "aws_ssm_parameter" "secret" {
    name  = "/${var.environment}/${data.terraform_remote_state.beanstalk.name}/api-key"
    type  = "SecureString"
    value = "${random_string.password.result}"
}

module "ecloud-elasticbeanstalk-ec2-role" {
    source                                        = "git@github.com:esure-dev/inf-ter-beanstalk-role"
    name                                          = "ecloud-elasticbeanstalk-ec2-role-SUFFIX-${var.environment}"
    ecloud_cloudwatch_application_log_push_policy = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ecloud-cloudwatch-application-log-push"
}

module "beanstalk-environment" {
    source                                 = "git@github.com:esure-dev/inf-ter-beanstalk-environment.git?ref=v2.0"
    application_name                       = "${data.terraform_remote_state.beanstalk.name}"
    iam_instance_profile                   = "${module.ecloud-elasticbeanstalk-ec2-role.role}"
    service_role                           = "ecloud-elasticbeanstalk-service-role"
    instance_type                          = "t3.small"
    security_groups                        = "${data.terraform_remote_state.infrastructure.default_security_group_id}"
    max_size                               = "${var.max_size}"
    min_size                               = "${var.min_size}"
    load_balancer_type                     = "classic"
    system_type                            = "enhanced"
    rolling_update_enabled                 = "true"
    rolling_update_type                    = "Health"
    min_instances_in_service               = "${var.min_instances_in_service}"
    max_batch_size                         = "${var.max_batch_size}"
    cross_zone                             = "false"
    batch_size                             = "100"
    batch_size_type                        = "Percentage"
    deployment_policy                      = "${var.deployment_policy}"
    connection_draining_enabled            = "true"
    log_publication_control                = "false"
    retention_in_days                      = "${var.retention_in_days}"
    stream_logs                            = "true"
    elb_subnets                            = "${local.elb_subnets}"
    app_subnets                            = "${data.terraform_remote_state.infrastructure.APPLICATION_NAME_subnets}"
    vpc_id                                 = "${data.terraform_remote_state.infrastructure.vpc_id}"
    certificate_arn                        = "${var.certificate_arn}"
    delete_on_termination                  = "false"
    application_health_check_url           = "HTTP:81/health"
    autoscale_statistic                    = "${var.autoscale_statistic}" 
    autoscale_measure_name                 = "${var.autoscale_measure_name}" 
    autoscale_upper_increment              = "${var.autoscale_upper_increment}" 
    autoscale_lower_bound                  = "${var.autoscale_lower_bound}" 
    autoscale_unit                         = "${var.autoscale_unit}" 
    autoscale_min                          = "${var.autoscale_min}" 
    autoscale_lower_increment              = "${var.autoscale_lower_increment}" 
    autoscale_upper_bound                  = "${var.autoscale_upper_bound}" 
    environment                            = "${var.environment}"
    tags                                   = "${var.tags}"
    scheduled_action_variables             = "${var.scheduled_action_variables}"
    environment_variables                  = [{ "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "ADMIN_PORT"
                                                "value"     = "81" },
                                              { "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "ADMIN_SERVER_URL"
                                                "value"     = "https://web-jva-springbootadmin-${var.profile}.escloud.co.uk" },
                                              { "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "APP_PORT"
                                                "value"     = "80" },
                                              { "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "CONFIG_SERVER_URL"
                                                "value"     = "https://api-jva-springbootconfig-${var.profile}.escloud.co.uk" },
                                              { "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "DYNATRACE"
                                                "value"     = "${var.dynatrace}" },
                                              { "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "ENV"
                                                "value"     = "${var.environment}" },
                                              { "namespace" = "aws:elasticbeanstalk:application:environment"
                                                "name"      = "MODE"
                                                "value"     = "${var.mode}" }]
}

provider "aws" {
    alias   = "g1"
    profile = "default"
    region  = "${var.region}"
}

resource "aws_route53_record" "record" {
    provider = "aws.g1"
    zone_id  = "Z57L0GQOFE23V"
    name     = "${data.terraform_remote_state.beanstalk.name}-${var.environment}.escloud.co.uk"
    type     = "A"

    alias {
        name    = "${data.terraform_remote_state.beanstalk.name}-${var.environment}.eu-west-1.elasticbeanstalk.com"
        zone_id = "Z2NYPWQ7DFZAZH"
        evaluate_target_health = false
    }
}

variable "region" {}
variable "profile" {}
variable "max_size" {}
variable "min_size" {}
variable "min_instances_in_service" {}
variable "max_batch_size"{}
variable "retention_in_days" {}
variable "certificate_arn" {}
variable "deployment_policy" {
  default = "RollingWithAdditionalBatch"
}
variable "tags" {
  type = "map"
}
variable "scheduled_action_variables" {
  type    = "list"
  default = []
}
# Environment Variables
variable "dynatrace" {}
variable "environment" {}
variable "mode" {}
# Auto-scaling variables
variable "autoscale_measure_name" {
  default     = "CPUUtilization"
  description = "Metric used for your Auto Scaling trigger"
}
variable "autoscale_statistic" {
  default     = "Average"
  description = "Statistic the trigger should use, such as Average"
}
variable "autoscale_unit" {
  default     = "Percent"
  description = "Unit for the trigger measurement, such as Bytes"
}
variable "autoscale_lower_bound" {
  default     = "20"
  description = "Minimum level of autoscale metric to remove an instance"
}
variable "autoscale_lower_increment" {
  default     = "-1"
  description = "How many Amazon EC2 instances to remove when performing a scaling activity."
}
variable "autoscale_upper_bound" {
  default     = "80"
  description = "Maximum level of autoscale metric to add an instance"
}
variable "autoscale_upper_increment" {
  default     = "1"
  description = "How many Amazon EC2 instances to add when performing a scaling activity"
}
variable "autoscale_min" {
  default     = "2"
  description = "Minumum instances in charge"
}
