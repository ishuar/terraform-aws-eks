resource "aws_route53_zone" "internet_alb" {
  name = "worldofcontainers.tk" ## please update this with domain name what you own.
}

## If hosting domain outside of AWS, then verify that domain resolution is forwarded to following nameservers.
output "zone_name_servers" {
  value = aws_route53_zone.internet_alb.name_servers
}
