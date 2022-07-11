# terraform-ansible
This demo will help you with up & running a basic AWS infrastructure for an ansible deployment, This will create VPC, Subnets, instance, and security-group, and will copy a tar file consisting of Dockerfile in those servers and publish it publicly on port 80 with Nginx proxy. it'll do the same for ubuntu/centOS distribution.
  
# prerequisite
1. to run this code, one needs to have Linux/mac/WSL2 to run this code.
2. For this I'm using Terraform v1.1.9, ansible 2.9.6, and java OpenJDK 11.0.13 version.
3. It'll be good if you have AWScliV2 configured.
4. A basic Dockrfile Configured inside a tar file. Using Nginx can be good for the demo.

# requirements
1. Create a terraform.tfvars file and add values to all the variables mentioned in variables.tf.
2. Add `AWS_ACCESS_KEY/AWS_SECRET_KEY` as a variable or you can update them in .aws/credential file.
3. Place Above mentioned tar file into the ansible folder. 
4. edit **ansible/nginx-install.yaml** with the tar file changes.(only for ubuntu/Debian)
5. Do the same as step 4 in **ansible/cent-os-nginx.yaml**.(only for CentOS/RHEL)

# How-To-Run
1. after creating all the files use the below command to initialize terraform.
 - `terraform init`
2. After successfully initializing use the below command to test/validate all the tf configurations
 - `terraform plan`
3. if no red Flags are observed :+1: use the below command to apply the config files.
- `terraform apply`

# What-To-Expect
1. When we run terraform apply, after creating AWS services it will apply ansible playbooks by itself.
2. After the completion we will get 2 IP Addresses that we can run on any browser, and it will give us Nginx starting page.
3. if some error shows up it will be mostly related to ansible playbooks path correction. 

# AWS-eks-setup
- For EKS Setup one needs to go inside the eks directory and use the below commands to get eks cluster UP & Running in AWS.
 - `terraform init` **To start terraform**
 - `terraform plan` **To validate terraform**
 - `terraform apply` **To apply the conf files**

> NOTE:  EKS setup is different from aws Instance/ansible setup.
