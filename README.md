### Weighted routing using AWS ALB Ingress controller

This example illustrates using AWS Load balancer weighted routing to different docker images (java application, reactui app, static html)

- Make sure to replace your cluster name, region, account number and eks_vpc_id (after eks cluster creation)
- Mak sure to have eksctl, helm, kubectl installed on your machine
- For testing sake there are two docker images that are used from my public repo (on the k8s.yaml for the k8s service)
- Weighted routing is provided in the ingress - 50% to each service/deployments

```
YOUR_CLUSTER_NAME=my-eks
YOUR_REGION=us-east-1
YOUR_ACCOUNT_NUMBER=<PUT_IT_HERE>

eksctl create cluster --name $YOUR_CLUSTER_NAME --version 1.18 --fargate
eksctl utils associate-iam-oidc-provider --cluster $YOUR_CLUSTER_NAME --approve

eksctl create iamserviceaccount \
  --cluster=$YOUR_CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::$YOUR_ACCOUNT_NUMBER:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

EKS_VPC_ID=<REPLACE_AFTER_BELOW_EKSCTL>

eksctl get iamserviceaccount --cluster $YOUR_CLUSTER_NAME --name aws-load-balancer-controller --namespace kube-system

kubectl get serviceaccount aws-load-balancer-controller --namespace kube-system

helm repo add eks https://aws.github.io/eks-charts

  helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    --set clusterName=$YOUR_CLUSTER_NAME \
    --set serviceAccount.create=false \
    --set region=$YOUR_REGION \
    --set vpcId=$EKS_VPC_ID \
    --set serviceAccount.name=aws-load-balancer-controller \
    -n kube-system


eksctl create fargateprofile --cluster $YOUR_CLUSTER_NAME --region $YOUR_REGION --name springboot-app --namespace springboot    

kubectl apply -f k8s.yaml

kubectl -n springboot ingress/ingress-springboot 

kubectl -n get deployment

kubectl -n springboot get pods

kubectl -n springboot get svc

```

### Can point to different doccker containers having Java/Html/ReactUI app for testing

- java
  - k8s containers: shivaramani/springboot and shivaramani/springbootexternalservice
  - ingress path: /sayhello  

- reactjs
  - k8s containers: shivaramani/reactuiapp
  - ingress path: /*

- html
  - k8s containers: shivaramani/htmlapp
  - ingress path: /html

### Testing

curl http://k8s-springbo-ingresss-97047f542b-2010574010.us-east-1.elb.amazonaws.com/sayhello?name=shiva

- notice the response shown from different pods/services

