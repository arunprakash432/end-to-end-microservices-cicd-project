provider "aws" {
  region = "ap-south-1" # Change as needed
}

# -------------------------
# S3 Bucket for Terraform State
# -------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = "opentelemetry-state-bucket-12345" # must be globally unique

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}

# Enable versioning (VERY IMPORTANT)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access (best practice)
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -------------------------
# DynamoDB Table for State Locking
# -------------------------
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "opentelemetry-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "Dev"
  }
}