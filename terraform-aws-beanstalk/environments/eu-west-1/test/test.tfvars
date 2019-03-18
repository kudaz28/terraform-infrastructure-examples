region                                 = "eu-west-1"
profile                                = "test"
max_size                               = "2"
max_batch_size                         = "1"
min_size                               = "1"
min_instances_in_service               = "1"
retention_in_days                      = "7"
delete_on_termination                  = "false"
certificate_arn                        = "arn:aws:acm:eu-west-1:375857942905:certificate/fdeb7850-0fa1-4303-beb1-9209c8fd8563"
# Environment Variables
dynatrace                              = "false"
environment                            = "ENVIRONMENT"
mode                                   = "test"
# Environment Tags
tags = { "account"                = "test",
         "cost-center"            = "INSERT COST CENTER",
         "environment"            = "ENVIRONMENT",
         "environment-owner"      = "INSERT ENVIRONMENT OWNER",
         "environment-type"       = "api",
         "expiry-date"            = "n/a",
         "instance-run-days"      = "n/a",
         "instance-shutdown-time" = "n/a",
         "instance-startup-time"  = "n/a",
         "name"                   = "APPLICATION_NAME-ENVIRONMENT",
         "patch-group"            = "elastic-beanstalk-ENVIRONMENT-linux",
         "project-code"           = "INSERT PROJECT CODE",
         "project-name"           = "INSERT PROJECT NAME",
         "service-name"           = "APPLICATION_NAME",
         "template"               = "api",
         "ticket-number"          = "jira-xxxx"
}
scheduled_action_variables = [
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaledown"
    "name"      = "MaxSize"
    "value"     = "0"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaledown"
    "name"      = "MinSize"
    "value"     = "0"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaledown"
    "name"      = "DesiredCapacity"
    "value"     = "0"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaledown"
    "name"      = "Recurrence"
    "value"     = "0 19 * * 1-5"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaleup"
    "name"      = "MaxSize"
    "value"     = "2"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaleup"
    "name"      = "MinSize"
    "value"     = "1"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaleup"
    "name"      = "DesiredCapacity"
    "value"     = "1"
  },
  {
    "namespace" = "aws:autoscaling:scheduledaction"
    "resource"  = "scaleup"
    "name"      = "Recurrence"
    "value"     = "0 7 * * 1-5"
  }
]

