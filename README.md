# logherder

## Overview

I would have named it logflume but that was already taken. In real life
the log herder is the person who stands by the flume and makes sure all
the logs get through. In this case the logherder parses the logs and
writes them to logstash. Oh, and for good measure, sets up
logstash/kibana and elasticsearch.

In this version, it also sets up a local haproxy which is configured to
forward port 80 to a local Kibana installation. The haproxy logs are
sent to logstash, so after browsing around Kibana a bit some data will
appear in the sample dashboards.

## Deployment
### Via AWS Console
1. Log in to the AWS console
1. Go to Services -> CloudFormation
1. Mash the Create Stack button
1. Fill in the parameters and click a few buttons
1. Get your instance's public DNS name from the Outputs tab
1. ssh to it or hit it from your browser

### Via command line

1. Make sure you have the [AWS CLI tools](http://aws.amazon.com/cli/) installed and configured
1. Modify params.json to suit your purposes. At a minimum you'll want to
   update AllowedIpPrefix
1. Deploy with the following commands (changing your aws profile and target region as needed)
    ```
    aws_profile=default
    region=us-east-1
    stack_name=LogHerder
    aws --profile $my_aws_profile cloudformation create-stack --stack-name $stack_name --region $region --template-body file://logherder.json --parameters file://params.json
    ```
1. Once the stack creation is done, the instance's public IP will show up in the Outputs section of this command:
    ```
    aws --profile nik.weidenbacher_at_gmail.com cloudformation --region us-east-1 describe-stacks --stack-name $stack_name
    ```
1. ssh to it or hit it from your browser
