#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
local_ipv4=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)
az=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
instance_id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head><title>DJ's World</title></head>
<body>
  <h1>DJ's World</h1>
  <h2>Chains Broken in America</h2>
  <p><b>Instance ID:</b> $instance_id</p>
  <p><b>Private IP:</b> $local_ipv4</p>
  <p><b>Availability Zone:</b> $az</p>
</body>
</html>
HTML