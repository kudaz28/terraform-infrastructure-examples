# inf-ter-beanstalk
This repository contains the Terraform modules and environment settings for creating a production ready Beanstalk application and environment in AWS.

* [What is Beanstalk?](#what-is-beanstalk)
* [Beanstalk infrastructure in AWS](#beanstalk-infra)
* [Configuration layout](#config-layout)

## What is beanstalk
AWS Elastic Beanstalk is a cloud deployment and provisioning service that automates the process of getting applications set up on the Amazon Web Services (AWS) infrastructure. The full Documentation about Beanstalk can be found [here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html).

## Beanstalk Infrastructure
![beanstalk-infra](img/aeb-architecture_worker.png)

What are we creating:

* Beanstalk application.
* Beanstalk environment.
* A specific role base on the environment.
* Modified default security groups.

## Terraform Module
To be able to create the Esure specific infrastructure, we wll be using terraform. The current version tested with this repository is v0.11.1. 

There are 2 modules in the repository, application and environment. The application module creates the beanstalk app and the environment module creates the beanstalk environments. There can be multiple environments attached to an application.

### Configuration layout

