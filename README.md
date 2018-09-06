# cloudnative-sample

## Create vpc, ecs, fargate
`cd cluster`
`aws cloudformation create-stack --stack-name mystack --capabilities CAPABILITY_IAM --template-body file://public-private-vpc.yml`

