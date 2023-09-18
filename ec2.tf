resource "aws_instance" "ec_cube" {
  ami           = "ami-0f89bdd365c3d966d" # Amazon Linux 2023(x86) (HVM) - Kernel 5.10, SSD Volume Type 
  instance_type = "t3.large"
  # create secret key and set the key name on 'key_name' below
  # see: https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-key-pairs.html
  key_name                    = var.my_key_name
  subnet_id                   = aws_subnet.ec_cube_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec_cube_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  count                       = 1
  associate_public_ip_address = true
  tags = {
    Name = "ec-cube"
  }
}