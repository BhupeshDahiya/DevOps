resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "tf-sg" {
  name        = "Tf-sg"
  description = "Sg for tf"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "tf-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_myip" {
  security_group_id = aws_security_group.tf-sg.id
  cidr_ipv4         = "106.222.200.129/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_http_in" {
  security_group_id = aws_security_group.tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_out" {
  security_group_id = aws_security_group.tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_out" {
  security_group_id = aws_security_group.tf-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}