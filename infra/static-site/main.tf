# --- S3: bucket privato per i file buildati ---
resource "aws_s3_bucket" "site" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "own" {
  bucket = aws_s3_bucket.site.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- CloudFront: OAC per accedere a S3 privato ---
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project}-${var.env}-oac"
  description                       = "OAC for S3 private origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  comment             = "${var.project}-${var.env}"
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies { forward = "none" }
    }
  }

  # Fallback SPA: manda 403/404 a index.html (router client-side)
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate { cloudfront_default_certificate = true } # niente dominio custom per ora
}

# --- Policy del bucket: consenti a CloudFront (via OAC) di leggere ---
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid      = "AllowCloudFrontReadViaOAC",
      Effect   = "Allow",
      Principal= { Service = "cloudfront.amazonaws.com" },
      Action   = ["s3:GetObject"],
      Resource = ["${aws_s3_bucket.site.arn}/*"],
      Condition= {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
        }
      }
    }]
  })
}

# --- Output utili ---
output "bucket_name"       { value = aws_s3_bucket.site.bucket }
output "distribution_id"   { value = aws_cloudfront_distribution.cdn.id }
output "cloudfront_domain" { value = aws_cloudfront_distribution.cdn.domain_name }
