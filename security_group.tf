resource "aws_security_group" "ec_cube_sg" {
  name        = "ec-cube-sg"
  description = "for ec cube"
  vpc_id      = aws_vpc.ec_cube_vpc.id
  tags = {
    Name = "ec-cube-sg"
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    to_port          = 0
  }
  ingress {
    cidr_blocks     = [local.my_home_cidr]
    description     = "My IP address"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = []
  }
}