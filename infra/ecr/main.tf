terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "tf-state-quote-calculator-eu-south-1"
    key            = "ecr/terraform.tfstate"
    region         = "eu-south-1"
    dynamodb_table = "tf-lock-quote-calculator"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-south-1"
}

# Repository ECR per il backend
resource "aws_ecr_repository" "backend" {
  name                 = "quote-backend"
  image_tag_mutability = "MUTABLE" # in dev ok, in prod valuteremo IMMUTABLE
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration { encryption_type = "AES256" }
  force_delete = true
  tags = { project = "quote-calculator", env = "dev", component = "backend" }
}

# Lifecycle: tieni solo le ultime 10 immagini per non sprecare spazio
resource "aws_ecr_lifecycle_policy" "retention" {
  repository = aws_ecr_repository.backend.name
  policy     = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "Keep last 10 images",
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 10 },
      action       = { type = "expire" }
    }]
  })
}

output "repository_url" {
  value = aws_ecr_repository.backend.repository_url
}
