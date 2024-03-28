# EKS 



## Getting started

To make it easy for you to get started with EKS, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:




This is the full configuration from [AWS EKS Getting Started](https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html)

See that guide for additional information.

```
# Update your k8 context with the new cluster name. clean existing configs first

# Now you can kubectl to get access to the cluster

echo "" > ~/.kube/config
aws eks update-kubeconfig --name terraform-eks-demo

# Update kubeconfig 
this for a second piece of context - below use kubernetes context whereas the one above use terraform-eks-demo context. need more research. you can skip applying the below context. since the one above works fine for me

terraform output kubeconfig >kubeconfig.yaml

# maps the IAM node instance to Kubernetes groups so that nodes can register themselves with the cluster

terraform output config_map_aws_auth >aws-auth.yaml

# apply the config map to the cluster

kubectl apply  -f aws-auth.yaml -n kube-system
# verify cm
kubectl get cm -n kube-system
```
# To test out helm

```
helm install happy-panda bitnami/wordpress

```
# Grafana and Prometheus
```
[source](https://www.coachdevops.com/2022/05/how-to-setup-monitoring-on-kubernetes.html)
    - helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    - helm search repo prometheus-community
    - kubectl create namespace prometheus
    # from all the charts listed by helm search we using kube-prometheus-stack
    - helm install stable prometheus-community/kube-prometheus-stack -n prometheus 
    - kubectl --namespace prometheus get pods 
    - kubectl --namespace prometheus get svc
    # update the prometheus and grafana services to use LoadBalancer instead of ClusterIP
    - kubectl edit svc -n prometheus stable-kube-prometheus-sta-prometheus
    - kubectl edit svc -n prometheus stable-grafana
    # Or you can do port forwarding for prometheus service like below. and deploy grafana as ClusterIP to begin with
    kubectl -n prometheus port-forward prometheus-stable-kube-prometheus-sta-prometheus-0  9090
    # verify services for grafana and prometheus is using LoadBalancer
    - kubectl --namespace prometheus get svc 
    # navigate to the External-IP of grafana and prometheus:9090 on browser to see the application
    # for grafana the default login admin/prom-operator
    # create a kuberenetes dashboard by importing the JSON file 12740 
```

```
# GitLab K8 runner

```
helm repo add gitlab https://charts.gitlab.io
helm repo update gitlab
helm search repo -l gitlab/gitlab-runner
kubectl create ns gitlab-ns  
helm install --namespace gitlab-ns gitlab-runner -f values.yaml gitlab/gitlab-runner


```

# RBAC configuration

#

#

## Create IAM user

```aws iam create-user --user-name rbac-user
aws iam create-access-key --user-name rbac-user | tee /tmp/create_output.json
```
## Store Creds in rbacuser_creds.sh

## Map IAM user to k8

```cat << EoF >> aws-auth.yaml
data:
mapUsers: | - userarn: arn:aws:iam::${ACCOUNT_ID}:user/rbac-user
username: rbac-user
EoF
```
# Apply the configMap

kubectl apply -f aws-auth.yaml

# Create a Role and Role Binding

```
        cat << EoF > rbacuser-role.yaml
        kind: Role
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
        namespace: rbac-test
        name: pod-reader
        rules:
        - apiGroups: [""] # "" indicates the core API group
        resources: ["pods"]
        verbs: ["list","get","watch"]
        - apiGroups: ["extensions","apps"]
        resources: ["deployments"]
        verbs: ["get", "list", "watch"]
        EoF
 # Role Binding
        cat << EoF > rbacuser-role-binding.yaml
        kind: RoleBinding
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
        name: read-pods
        namespace: rbac-test
        subjects:
        - kind: User
        name: rbac-user
        apiGroup: rbac.authorization.k8s.io
        roleRef:
        kind: Role
        name: pod-reader
        apiGroup: rbac.authorization.k8s.io
        EoF

```

# Apply the role and role binding

```kubectl apply -f rbacuser-role.yaml
kubectl apply -f rbacuser-role-binding.yaml
```
# Switch to new user and verify access

kubectl get pods -n rbac-test

# Clean up

```
    kubectl delete namespace rbac-test
    rm rbacuser_creds.sh
    rm rbacuser-role.yaml
    rm rbacuser-role-binding.yaml
    aws iam delete-access-key --user-name=rbac-user --access-key-id=$(jq -r .AccessKey.AccessKeyId /tmp/create_output.json)
    aws iam delete-user --user-name rbac-user
    rm /tmp/create_output.json

```

 Query the cluster - note the filter from bethsda oct-14-2023 at paul oursman beats newmac coffee rainy day
 \| filter by catagory
 
```kubectl  describe node | grep 'Name:\|Allocated resources:\|PodCIDR:' -A 5 | grep 'Name:\|cpu\|memory'```