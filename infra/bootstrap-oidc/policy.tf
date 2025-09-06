# policy.tf — Permessi minimi per deploy frontend

# Valori da passare in apply (vedi comando più sotto)
variable "static_bucket_name" { type = string }   # es: quote-calculator-dev-frontend-123456789012
variable "distribution_id"    { type = string }   # es: E1ABCDEFG2HIJK

data "aws_caller_identity" "me" {}

# Documento policy: S3 (bucket+oggetti) + CloudFront Invalidation
data "aws_iam_policy_document" "deploy_policy_doc" {
  statement {
    sid     = "S3ListBucket"
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.static_bucket_name}"]
  }

  statement {
    sid     = "S3ObjectsCRUD"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.static_bucket_name}/*"]
  }

  statement {
    sid     = "CloudFrontInvalidate"
    actions = ["cloudfront:CreateInvalidation"]
    resources = ["arn:aws:cloudfront::${data.aws_caller_identity.me.account_id}:distribution/${var.distribution_id}"]
  }
}

resource "aws_iam_policy" "deploy_policy" {
  name   = "github-deploy-frontend-policy"
  policy = data.aws_iam_policy_document.deploy_policy_doc.json
}

# Collega la policy al ruolo già creato (aws_iam_role.github_deploy)
resource "aws_iam_role_policy_attachment" "attach_deploy" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}
