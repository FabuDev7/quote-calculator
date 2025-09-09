moved {
  from = aws_iam_role.github_deploy
  to   = aws_iam_role.github_deploy_frontend
}

moved {
  from = aws_iam_policy_document.deploy_policy_doc
  to   = aws_iam_policy_document.frontend_deploy_doc
}

moved {
  from = aws_iam_policy.deploy_policy
  to   = aws_iam_policy.frontend_deploy
}

moved {
  from = aws_iam_role_policy_attachment.attach_deploy
  to   = aws_iam_role_policy_attachment.frontend_attach
}
