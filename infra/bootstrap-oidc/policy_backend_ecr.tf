# policy_backend_ecr.tf — Ruolo OIDC per build & push su ECR (backend)

# Permission policy minima per push su ECR
data "aws_iam_policy_document" "backend_ecr_deploy_doc" {
  # token di login ECR (richiede Resource="*")
  statement {
    sid       = "EcrAuthToken"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # operazioni di push/pull sul repository specifico
  statement {
    sid = "EcrPushPull"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [local.ecr_repo_arn]
  }
}

resource "aws_iam_policy" "backend_ecr_deploy" {
  name   = "github-deploy-backend-ecr-push"
  policy = data.aws_iam_policy_document.backend_ecr_deploy_doc.json
}

resource "aws_iam_role_policy_attachment" "backend_ecr_attach" {
  role       = aws_iam_role.github_deploy_backend.name
  policy_arn = aws_iam_policy.backend_ecr_deploy.arn
}
