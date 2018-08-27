# cloudnative-sample

## Create cluster in develop, staging, production
`bash cluster/cluster.sh start develop`

## Create   ingress and config domain
`kubectl create -f ingress/develop.yaml -ndevelop`

## Deploy Drone CD tool in k8s
- `brew install kubernetes-helm`
- `helm install incubator/drone`
