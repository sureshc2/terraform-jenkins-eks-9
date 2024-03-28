pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sureshc2/terraform-jenkins-eks-9.git']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Creating an EKS Cluster'){
            steps{
                script{
                    dir('EKS') {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('EKS/ConfigurationFiles') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'helm repo add prometheus-community https://prometheus-community.github.io/helm-charts'
                        sh 'kubectl create namespace prometheus'
                        sh 'helm install stable prometheus-community/kube-prometheus-stack -n prometheus'
                        sh 'kubectl --namespace prometheus get pods'
                        sh 'kubectl --namespace prometheus get svc'
                        sh 'kubectl edit svc -n prometheus stable-kube-prometheus-sta-prometheus'
                        sh 'kubectl edit svc -n prometheus stable-grafana'
                        sh 'kubectl --namespace prometheus get svc'
                    }
                }
            }
        }
    }
}
