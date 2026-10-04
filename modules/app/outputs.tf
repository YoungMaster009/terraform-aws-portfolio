output "instance_profile_name" {
  value = aws_iam_instance_profile.instance.name
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.site.certificate_arn
}

output "assets_bucket" {
  value = aws_s3_bucket.assets.id
}