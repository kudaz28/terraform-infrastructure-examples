region                                 = "eu-west-1"
profile                                = "prep"
max_batch_size                         = "1"
max_size                               = "3"
min_size                               = "3"
min_instances_in_service               = "2"
retention_in_days                      = "365"
delete_on_termination                  = "false"
certificate_arn                        = "arn:aws:acm:eu-west-1:340864205732:certificate/e91ce0d5-df39-4b07-b3dc-d87cfbf00d8c"
# Environment Variables
dynatrace                              = "true"
environment                            = "prep"
mode                                   = "prep"
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

