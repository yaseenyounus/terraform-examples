resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-core-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "ssm_core_policy" {
  name       = "ec2-ssm-core-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.ec2_ssm_role.name]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "minikube-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "minikube_ec2" {
  ami                         = "ami-0889a44b331db0194"
  instance_type               = "t2.medium"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = file("user_data.sh")
  user_data_replace_on_change = true

  tags = {
    "Name" : "minikube"
  }
}
