region                                 = "eu-west-1"
profile                                = "prod"
max_size                               = "6"
max_batch_size                         = "1"
min_size                               = "3"
min_instances_in_service               = "2"
retention_in_days                      = "365"
delete_on_termination                  = "false"
certificate_arn                        = "arn:aws:acm:eu-west-1:706665555773:certificate/64fae0f6-dd31-4dc3-bffa-b36e46e18504"
# Environment Variables
dynatrace                              = "true"
environment                            = "prod"
mode                                   = "prod"
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

