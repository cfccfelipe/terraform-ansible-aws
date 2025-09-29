terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-felipe-99009900"
    key            = "env/qa/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-felipe-99009900"
    encrypt        = true
  }
}
