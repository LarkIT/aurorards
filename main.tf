resource "aws_route53_zone" "external" {
  count   = "${var.external_dns_enable}"
  name    = "${var.external_domain_name}"
  comment = "External Domain"
}

resource "aws_route53_zone" "internal" {
  name   = "${var.internal_domain_name}"
  comment = "Internal Domain"
  vpc_id = "${var.vpc_id}"
}

resource "aws_vpc_dhcp_options" "internal" {
  domain_name = "${var.internal_domain_name}"
  domain_name_servers = [ "${var.domain_name_servers}" ]

  tags = {
    Name = "internal"
  }
}

resource "aws_vpc_dhcp_options_association" "internal" {
  vpc_id          = "${var.vpc_id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.internal.id}"
}
