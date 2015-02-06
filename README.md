# logherder

I would have named it logflume but that was already taken. In real life
the log herder is the person who stands by the flume and makes sure all
the logs get through. In this case the logherder parses the logs and
writes them to logstash. Oh, and for good measure, sets up
logstash/kibana and elasticsearch.

To deploy with AWS CLI:

```
aws_profile=my_aws_profile
region=us-east-1
aws --profile $my_aws_profile cloudformation create-stack --stack-name LogHerder --region $region --template-body file://logherder.json --parameters file://params.json
```
