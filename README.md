# cloudnative-sample

## Create vpc, ecs, fargate
`cd cluster`
`aws cloudformation create-stack --stack-name develop --capabilities CAPABILITY_IAM --template-body file://public-private-vpc.yml`

## Deploy a service on AWS Fargate, hosted in a private subnet, but accessible via a public load balancer.
`cd service-stacks`
`aws cloudformation create-stack --stack-name service-stack --capabilities CAPABILITY_IAM --template-body file://private-subnet-public-loadbalancer.yml`

## Create jenkins server
`cd service-stacks`
`aws cloudformation create-stack --template-body file://jenkins.yml --stack-name JenkinsStack --capabilities CAPABILITY_IAM --tags Key=Name,Value=Jenkins --parameters ParameterKey=EcsStackName,ParameterValue=EcsClusterStack`

## Create drone service
`cd service-stacks`
`aws cloudformation create-stack --stack-name drone-ci --template-body file://template.json --parameters file://params.json --capabilities CAPABILITY_IAM`

`aws cloudformation describe-stacks --stack-name drone-ci --query 'Stacks[0].Outputs[0].OutputValue' --output text`

