### DNS/DHCP Configuration

resource "aws_route53_zone" "external" {
  count   = "${var.external_dns_enable}"
  name    = "${var.external_domain_name}"
  comment = "External Domain"
}

output "external-dns-servers" {
  value = "${aws_route53_zone.external.name_servers} (${var.external_domain_name})"
}

resource "aws_route53_zone" "internal" {
  name   = "${var.internal_domain_name}"
  comment = "Internal Domain"
  vpc_id = "${var.vpc_id}"
}

resource "aws_vpc_dhcp_options" "internal" {
  domain_name = "${var.internal_domain_name}"
  domain_name_servers = [ "${cidrhost("${var.vpc_cidr}", 2)}" ]

  tags = {
    Name = "internal"
  }
}

#resource "aws_vpc_dhcp_options_association" "internal" {
#  vpc_id          = "${aws_vpc.production.id}"
#  dhcp_options_id = "${aws_vpc_dhcp_options.internal.id}"
#}