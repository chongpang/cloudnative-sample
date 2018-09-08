# cloudnative-sample

## Create vpc, ecs, fargate
`cd cluster`
`aws cloudformation create-stack --stack-name develop --capabilities CAPABILITY_IAM --template-body file://vpc.yml`

## Deploy a service on AWS Fargate, hosted in a private subnet, but accessible via a public load balancer.
`cd service-stacks`
`aws cloudformation create-stack --stack-name service-stack --capabilities CAPABILITY_IAM --template-body file://nginx-ecs-fargate.yml`

## Create jenkins server
`cd service-stacks`
`aws cloudformation create-stack --template-body file://jenkins-ecs-instance.yml --stack-name JenkinsStack --capabilities CAPABILITY_IAM --tags Key=Name,Value=Jenkins --parameters ParameterKey=EcsStackName,ParameterValue=EcsClusterStack`

## Create drone service
`cd service-stacks`
`aws cloudformation create-stack --stack-name drone-ci --template-body file://drone-ecs-instance.yml --capabilities CAPABILITY_IAM`

`aws cloudformation describe-stacks --stack-name drone-ci --query 'Stacks[0].Outputs[0].OutputValue' --output text`

