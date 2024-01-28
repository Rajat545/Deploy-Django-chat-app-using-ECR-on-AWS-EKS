
# Deploy Django ChatProject using AWS ECR to AWS EKS(K8s).

This is a simple Django 3.0+ project, implements Channels to deal with this simple Chat App 
Born to be private, only the owner (you, the admin) can create users. 
Register users can login and chat


# Prerequisites
Basic knowledge of Docker, and AWS services.
An AWS account with necessary permissions.

# Step 1: Fork the Repository

 Visit the original repository at [https://github.com/tilcara/ChatProject.git]  

 Click on the "Fork" button in the top-right corner of the GitHub page.

 Choose your GitHub account as the destination for the fork.


# Step 2: Create Dockerfile
Clone your forked repository to your local machine:

  git clone https://github.com/tilcara/ChatProject.git

 Navigate to the root directory of the cloned repository:

  `cd chatproject`

 Create a new file named Dockerfile:

  `vim Dockerfile`

 Open Dockerfile using a text editor and add the content from the above provided Dockerfile.

2.5 Save and close the file.

# Step 3: Build Docker Image

  `
  docker build -t chatproject:latest .
  `

# Step 4: Run Docker Container

  `docker run -p 8000:8000 chatproject:latest`

# Step 5: IAM Configuration
  Create a user eks-admin with AdministratorAccess.
  Generate Security Credentials: Access Key and Secret Access Key.

# Step 6: EC2 Setup
  Launch an Ubuntu instance in your favourite region (eg. region us-west-2).
  SSH into the instance from your local machine.

# Step 7: Install AWS CLI v2

 `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`

  `sudo apt install unzip`

  `unzip awscliv2.zip`

  `sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update`

  `aws configure`

# Step 8: Install Docker on ec2
 `sudo apt-get update`

  `sudo apt install docker.io`

  `docker ps`

  `sudo chown $USER /var/run/docker.sock`

# Step 9: Navigate to Amazon ECR
   In the AWS Management Console, search for "ECR" or navigate to the "Services" dropdown, find "ECR" under "Containers," and click on it.

# Step 10: Create a Repository
   In the Amazon ECR dashboard, click the "Create repository" button.

   Enter a unique name for your repository in the "Repository name" field.

# Step 11: Authenticate Docker to ECR
   After creating the repository, click on it to open its details.

    On the repository details page, you'll see a section titled "Push commands." These commands will authenticate Docker to your ECR registry.

    Copy and run the displayed commands in your terminal to authenticate Docker. This involves using the AWS CLI and executing the docker login command with the provided credentials.
   
   `aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com`

# Step 12: Push Docker Image to ECR
  Assuming you've built a Docker image locally (e.g., using a Dockerfile), tag your local image with the ECR repository URI.
  
  `docker tag chatprojecct:latest your-account-id.dkr.ecr.your-region.amazonaws.com/chatproject:latest`

  Push the tagged image to ECR:

   `docker push your-account-id.dkr.ecr.your-region.amazonaws.com/chatproject:latest`

# Step 13: Install kubectl

`curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl`

  `chmod +x ./kubectl`

  `sudo mv ./kubectl /usr/local/bin`

  `kubectl version --short --client`

# Step 14: Install eksctl

  `curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp`

  `sudo mv /tmp/eksctl /usr/local/bin`

  `eksctl version`

# Step 15: Setup EKS Cluster

  `eksctl create cluster --name chatproject --region us-west-2 --node-type t2.medium --nodes-min 1 --nodes-max 1`

  `aws eks update-kubeconfig --region us-west-2 --name chatproject`

 `` kubectl get nodes``

# Step 16: Run Manifests

 ``kubectl create namespace chat``

 ``kubectl config set-context --current --namespace chat``

 ``kubectl apply -f .``

 ``kubectl delete -f .``

# Step 17: Install AWS Load Balancer

`` `curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json``

 ``aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json``

 ``eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=three-tier-cluster --approve``

 ``eksctl create iamserviceaccount --cluster=chatproject --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::"your aws iam no.":policy/AWSLoadBalancerControllerIAMPolicy --approve --region=us-west-2``

# Step 18: Deploy AWS Load Balancer Controller

 ``sudo snap install helm --classic``

 ``helm repo add eks https://aws.github.io/eks-charts``

 ``helm repo update eks``

 ``helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=chatproject --set serviceAccount.create=false --set serviceAccountname=aws-load-balancer-controller``

 ``kubectl get deployment -n kube-system aws-load-balancer-controller``

 ``kubectl apply -f app_lb.yaml``

`` kubectl get ing -n chatproject``

  you will see your host name and address connect to DNS servers and update your domain in deployment.yaml and app_lb.yaml files.


 # Cleanup

  To delete the EKS cluster: 
  
  ``eksctl delete cluster --name chatproject --region us-west-2``

# Contribution Guidelines
 Fork the repository and create your feature branch.
 Deploy the application, adding your creative enhancements.
 Ensure your code adheres to the project's style and contribution guidelines.
 Submit a Pull Request with a detailed description of your changes.

## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


