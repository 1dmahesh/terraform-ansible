provider "kubernetes" {
    host = data.aws_eks_cluster.demo-eks-cluster.endpoint
    token = data.aws_eks_cluster_auth.demo-eks-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-eks-cluster.certificate_authority.0.data)
}


data "aws_eks_cluster" "demo-eks-cluster"{
    name = module.eks.cluster_id
}
 
data "aws_eks_cluster_auth" "demo-eks-cluster"{
    name = module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"
  
  cluster_name = "demo-eks-cluster"
  cluster_version = "1.20"

  subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
   
    tags = {
        environment = "dev"
        application = "my-demo"
    }

    worker_groups = [
     {
      name                          = "worker-group-1"
      instance_type                 = "t2.micro"
      asg_desired_capacity          = 2
     },
     {
      name                          = "worker-group-2"
      instance_type                 = "t2.micro"
      asg_desired_capacity          = 1
     },
  ]

}

