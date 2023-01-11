resource "aws_route53_zone" "internet_alb" {
  name = "worldofcontainers.tk"
}

## If hosting domain outside of AWS verify/add domain resolution is forwarded to following nameservers.
output "zone_name_servers" {
  value = aws_route53_zone.internet_alb.name_servers
}