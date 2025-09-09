terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "tf-state-quote-calculator-eu-south-1"
    key            = "static-site/terraform.tfstate"
    region         = "eu-south-1"
    dynamodb_table = "tf-lock-quote-calculator"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
