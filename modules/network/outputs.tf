output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = { for k, v in aws_subnet.this : k => v.id }
}

output "public_subnet_ids" {
  value = [for k, v in aws_subnet.this : v.id if var.subnets[k].public]
}

output "private_subnet_ids" {
  value = [for k, v in aws_subnet.this : v.id if !var.subnets[k].public]
}