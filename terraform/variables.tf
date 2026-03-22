variable "project_name" {
  description = "Name of the project, used as a prefix for all resources"
  type        = string
  default     = "opentelemetry-project"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# ─── VPC Variables ───────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for subnet deployment"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

# ─── EKS Variables ───────────────────────────────────────────────────────────

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes in the node group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes in the node group"
  type        = number
  default     = 4
}

# ─── Common Variables ─────────────────────────────────────────────────────────

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
