# terraform-aws-portfolio

A multi-tier AWS web stack built and deployed entirely with Terraform.

## What's built

- **Networking:** custom VPC across two availability zones, public and private subnets, NAT gateway
- **Compute:** Auto Scaling group behind an Application Load Balancer, rolling instance refresh on launch template changes
- **HTTPS:** ACM certificate with DNS validation through Route 53; HTTP redirects to HTTPS
- **Security:** optional AWS WAF (IP block list + AWS managed rules) behind a cost toggle, IAM instance role scoped to the assets bucket
- **State:** remote state in S3 with native locking
- **Structure:** reusable `network` and `compute` modules

The stack is torn down when not in use to keep costs low, so the live site isn't always up.

## In progress

- Separate dev and prod environments
- CI/CD with GitHub Actions and OIDC (no stored AWS keys)
- Full write-up: architecture diagram, cost breakdown, and problems solved

## Credits

Background video by Pachon in Motion via Pexels.
