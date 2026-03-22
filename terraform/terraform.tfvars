project_name = "opentelemetry-project"
aws_region   = "ap-south-1"

# VPC
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
availability_zones   = ["ap-south-1a", "ap-south-1b"]

# EKS
cluster_version    = "1.29"
node_instance_type = "t3.medium"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 4

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "my-project"
}
