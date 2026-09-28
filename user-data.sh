#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

aws s3 cp s3://${assets_bucket}/spacevideo.mp4 /var/www/html/spacevideo.mp4

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
az=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
instance_id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Built from the Ground Up</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { height: 100vh; overflow: hidden; font-family: system-ui, sans-serif; }
    video { position: fixed; top: 50%; left: 50%; min-width: 100%; min-height: 100%;
            transform: translate(-50%, -50%); object-fit: cover; z-index: -1; }
    .overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.55); z-index: 0; }
    .content { position: relative; z-index: 1; height: 100vh; display: flex;
               flex-direction: column; justify-content: center; align-items: center;
               text-align: center; color: #fff; padding: 2rem 2rem 14rem; }
    h1 { font-size: clamp(2rem, 8vw, 5rem); letter-spacing: 0.02em; }
    h2 { font-size: clamp(1rem, 3vw, 1.75rem); font-weight: 400; opacity: 0.9;
         margin-top: 0.5rem; }
    .stack { margin-top: 2rem; font-size: 0.95rem; opacity: 0.85; }
    .box { margin-top: 2rem; padding: 1rem 1.5rem; border: 1px solid rgba(255,255,255,0.3);
           border-radius: 6px; font-family: ui-monospace, monospace; font-size: 0.9rem;
           background: rgba(0,0,0,0.3); }
       @media (min-width: 900px) { .content { padding-bottom: 8rem; } }        
  </style>
</head>
<body>
  <video autoplay muted loop playsinline>
    <source src="spacevideo.mp4" type="video/mp4">
  </video>
  <div class="overlay"></div>
  <div class="content">
    <h1>Built from the Ground Up</h1>
    <h2>Every layer of this site is written in code</h2>
          <p class="stack">Deployed with Terraform &middot; AWS &middot; VPC &middot; EC2 &middot; Auto Scaling &middot; Load Balancing &middot; Route 53 &middot; HTTPS/ACM &middot; S3 &middot; IAM</p>
    <div class="box">
      served by $instance_id<br>
      availability zone $az
    </div>
  </div>
</body>
</html>
HTML