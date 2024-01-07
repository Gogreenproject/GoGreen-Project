resource "aws_route53_zone" "vampire" {
  name          = "vampire.org"
  comment       = "group 2 domain name"
  force_destroy = false
}

