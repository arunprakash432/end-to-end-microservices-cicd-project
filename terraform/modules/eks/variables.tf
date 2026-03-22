variable "project_name" {
  description = "Name of the project, used as a prefix for all resources"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster and node group"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required for EKS high availability."
  }
}

variable "node_instance_type" {
  description = "EC2 instance type for the worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
