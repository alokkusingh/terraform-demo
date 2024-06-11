# terraform-demo
Terraform Demo Project

```shell
brew uninstall terraform
brew install tfenv
TFENV_ARCH=amd64 tfenv install 1.8.4
tfenv use 1.8.4
```
```shell
terraform init -upgrade
```

```shell
aws eks update-kubeconfig --region ap-south-1 --name eks-demo --profile yahoo --role-arn=role/eks-demo-cluster-20240609093518521900000004
```
```shell
kubectl config set-context aws-yahoo --cluster=arn:aws:eks:ap-south-1:459283794779:cluster/eks-demo 
```
```shell
kubectl config use-context aws-yahoo
```
