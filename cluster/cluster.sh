#!bin/bash
#

set -e

node_count=3
node_type=t2.medium
region=ap-northeast-1
ns=("develop" "staging" "production")

if [ $# -ne 2 ]; then
  echo "Please specified at least 2 parameters.
	Usage: cluster.sh [ start | delete ] [ develop | staging | production ] " 1>&2
  exit 1
fi

action=$1
env=$2

if [[ "$env" != "production" && "$env" != "develop" && "$env" != "staging" ]]; then
	echo "Please specify develop, staging, prodcution"
fi

if type kops >/dev/null; then
    echo "kops cli installed."
else
    echo "Kops not found. Please read this.
https://kubernetes.io/docs/getting-started-guides/kops"
    exit 1
fi

if type docker >/dev/null 2>&1; then
  docker -v 
else
  echo Please install docker first.
  exit 1
fi

if type kubectl >/dev/null 2>&1; then
  echo kubectl installed.
else
  echo "Please install kubectl by running, 
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.5.2/bin/darwin/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl"
  exit 1
fi

cluser_name=${env}.k8s.local
export KOPS_STATE_STORE="s3://${cluser_name}/"

create_roles(){

  aws iam create-group --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops

  aws iam create-user --user-name kops
  aws iam add-user-to-group --user-name kops --group-name kops
  aws iam create-access-key --user-name kops
}

check_cluster(){

  running_node_count=0
	tried_count=0
  max_try=100
  # plus master
	node_count=$((node_count+1))
	while [ $running_node_count -lt $node_count ]
	do
		if [ $tried_count -gt $max_try ]; then
			echo Failed to start cluster ${cluster_env}
			exit 1
		fi

		running_node_count=$(kubectl get nodes | grep -o "Ready" | wc -l | awk '{gsub(/^ +| +$/,"")} {print $0}')
		echo Running node count is ${running_node_count}

		if [ $running_node_count -gt $node_count ]; then
			break
		else
			sleep 5s
			tried_count=$((tried_count+1))
		fi
  done
}

## Creating cluster
if [ "$action" = "start" ]; then
  echo Starting cluster: ${cluser_name} ...

  # for first run
  #create_roles

  # create s3 bucket
  aws s3api create-bucket --bucket ${cluser_name} --region ${region} --create-bucket-configuration LocationConstraint=${region}

	kops create cluster --cloud=aws \
	     --zones=ap-northeast-1c \
	     --node-count=$node_count \
	     --node-size=$node_type \
	     ${cluser_name}

	kops update cluster ${cluser_name} --yes

  check_cluster

  echo Cluster ${cluser_name} is ready.

  # create namespace
  kubectl create namespace develop

elif [ "$action" = "delete" ]; then

	echo Deleting cluster ${cluser_name} ...
	kops delete cluster ${cluser_name} --yes
  aws s3api delete-bucket --bucket ${cluser_name}
fi





