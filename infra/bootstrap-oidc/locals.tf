# ARN del repository ECR target
locals {
  ecr_repo_arn = "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"
}
