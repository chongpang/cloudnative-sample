## Build image and push to ECR

```
$(aws ecr get-login --no-include-email --region ap-northeast-1)

docker build -t jenkins .
docker tag jenkins:latest 301581106029.dkr.ecr.ap-northeast-1.amazonaws.com/jenkins:latest
docker push 301581106029.dkr.ecr.ap-northeast-1.amazonaws.com/jenkins:latest
```

## Deploy to ECS
sh deploy-stack-to-aws.sh 

