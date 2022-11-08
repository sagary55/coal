terraform {
  backend "s3" {
    bucket = "coalindia-cf"
    #dynamodb_table = "s3-terraform-eks-state-lock"
    key     = "acc-testing/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

