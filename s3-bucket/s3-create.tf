# AWS S3 bucket
# with block all public access#

provider "aws" {
  region  = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket
  acl    = "private"

  tags = {
    type        = "mybucket"
    environment = "dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "blocky" {
  bucket = aws_s3_bucket.mybucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
