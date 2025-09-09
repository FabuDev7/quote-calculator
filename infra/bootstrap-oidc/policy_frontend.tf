# policy-frontend.tf — Permessi minimi per deploy frontend

# Documento policy: S3 (bucket+oggetti) + CloudFront Invalidation
data "aws_iam_policy_document" "frontend_deploy_doc" {
  statement {
    sid       = "S3ListBucket"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.static_bucket_name}"]
  }

  statement {
    sid       = "S3ObjectsCRUD"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.static_bucket_name}/*"]
  }

  statement {
    sid       = "CloudFrontInvalidate"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.distribution_id}"]
  }
}

resource "aws_iam_policy" "frontend_deploy" {
  name   = "github-deploy-frontend-policy"
  policy = data.aws_iam_policy_document.frontend_deploy_doc.json
}

# Collega la policy al ruolo già creato (aws_iam_role.github_deploy)
resource "aws_iam_role_policy_attachment" "frontend_attach" {
  role       = aws_iam_role.github_deploy_frontend.name
  policy_arn = aws_iam_policy.frontend_deploy.arn
}
