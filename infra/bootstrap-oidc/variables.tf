variable "region" {
  type    = string
  default = "eu-south-1"
}
variable "ecr_repository_name" {
  type    = string
  default = "quote-backend"
}
# Valori da passare in apply
variable "static_bucket_name" { type = string }
variable "distribution_id" { type = string }
variable "repo" { type = string }


