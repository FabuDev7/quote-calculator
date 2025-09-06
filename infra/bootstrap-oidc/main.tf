terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "tf-state-quote-calculator-eu-south-1"
    key            = "bootstrap-oidc/terraform.tfstate"
    region         = "eu-south-1"
    dynamodb_table = "tf-lock-quote-calculator"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-south-1"
}

# Provider OIDC di GitHub (unico per account)
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  # Thumbprint corrente dell'issuer GitHub
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Repo GitHub autorizzato (owner/repo)
variable "repo" {
  type = string
  # es: "FabuDev7/quote-calculator"
}

# Ruolo che GitHub Actions potrà assumere via OIDC
resource "aws_iam_role" "github_deploy" {
  name = "github-deploy-frontend"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        },
        StringLike = {
          # Limita al TUO repo e al branch main (e tag se vuoi)
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.repo}:ref:refs/heads/main",
            "repo:${var.repo}:ref:refs/tags/*"
          ]
        }
      }
    }]
  })
}

# Nota: nessuna policy allegata qui.
# Dopo la Fase 1 attaccheremo la policy minima S3+CloudFront con le risorse reali.

output "role_arn" {
  value = aws_iam_role.github_deploy.arn
}
