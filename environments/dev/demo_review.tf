# DEMO ONLY: this file exists to show the AI plan review on a pull request. Never merge it.

resource "aws_security_group" "demo_review" {
  name        = "demo-ai-review"
  description = "Demo for the AI plan review. Never merge."

  ingress {
    description = "SSH from anywhere (intentionally bad)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "demo_admin" {
  name = "demo-ai-review-admin"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}