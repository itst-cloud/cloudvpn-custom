resource "aws_instance" "vpn" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.vpn_profile.name
  vpc_security_group_ids = [aws_security_group.vpn_sg.id]

  user_data = file("wireguard-docker/init.sh") # To install Docker + Compose
  tags = {
    Name = "CloudVPN-Docker"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.vpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.vpn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Replace with least-privilege version later
}
