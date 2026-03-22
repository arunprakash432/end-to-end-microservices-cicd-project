variable "project_name" {
  description = "Name of the project, used as a prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR must be provided."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR must be provided."
  }
}

variable "availability_zones" {
  description = "List of availability zones — must match the length of subnet CIDR lists"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be provided."
  }
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
