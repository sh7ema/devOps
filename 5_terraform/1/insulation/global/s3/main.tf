provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-test-shlema2"

  #Prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = true
  }

  #Run control version for look change history
  versioning {
    enabled = true
  }

  #Run encryption on server
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  hash_key = "LockID"
  name = "my-test-shlema-locks"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "my-test-shlema2"
    key = "my-test/mykey.tfstate"
    region = "eu-central-1"
    dynamodb_table = "my-test-shlema-locks"
    encrypt = true
  }
}