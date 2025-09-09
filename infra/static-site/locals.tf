locals {
  bucket_name = "${var.project}-${var.env}-frontend-${data.aws_caller_identity.current.account_id}"
}
