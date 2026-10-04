resource "aws_s3_bucket" "assets" {
  bucket = "${var.name_prefix}-app1-assets-590183753633"
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "video" {
  bucket      = aws_s3_bucket.assets.id
  key         = "spacevideo.mp4"
  source      = "${path.module}/../../spacevideo.mp4"
  source_hash = filemd5("${path.module}/../../spacevideo.mp4")
}

resource "aws_iam_role" "instance" {
  name = "${var.name_prefix}-app1-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "assets_read" {
  name = "${var.name_prefix}-app1-assets-read"
  role = aws_iam_role.instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject"]
      Resource = "${aws_s3_bucket.assets.arn}/*"
    }]
  })
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.name_prefix}-app1-instance-profile"
  role = aws_iam_role.instance.name
}

output "assets_bucket" {
  value = aws_s3_bucket.assets.id
}