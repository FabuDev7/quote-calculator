# Provider OIDC di GitHub (unico per account)
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # Thumbprint corrente dell'issuer GitHub
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Ruolo frontend che GitHub Actions potrà assumere via OIDC
resource "aws_iam_role" "github_deploy_frontend" {
  name = "github-deploy-frontend"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn },
      Action    = "sts:AssumeRoleWithWebIdentity",
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

# Ruolo backend che GitHub Actions potrà assumere via OIDC
resource "aws_iam_role" "github_deploy_backend" {
  name = "github-deploy-backend"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn },
      Action    = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        },
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.repo}:ref:refs/heads/main",
            "repo:${var.repo}:ref:refs/tags/*"
          ]
        }
      }
    }]
  })
}
