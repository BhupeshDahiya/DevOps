resource "aws_instance" "tf_instance" {
  ami                    = data.aws_ami.ami_id.id #get ami-d from the output of instanceid.tf
  instance_type          = "t3.micro"
  key_name               = "Tf-key" #Key name from keypair.tf
  vpc_security_group_ids = [aws_security_group.tf-sg.id] #sg module is called vpc_s-g-ids, deaitls from secgrp.tf
  availability_zone      = "us-east-1a"
  user_data              = file("${path.module}/web.sh") # path to the script to be run for instance,${path.module} - a built-in function that returns the filesystem path to the directory containing the module where the expression is placed

  tags = {
    Name = "Tf-ec2"
  }

}
# Tf cant check if you manually switch off an instance through dashboad, this block ensures that,
# whenever apply is run the instance state is matched 
resource "aws_ec2_instance_state" "tf_instance" {
  instance_id = aws_instance.tf_instance.id
  state       = "running"
}

output "Pub_ip" {
  description = "IP"
  value       = aws_instance.tf_instance.public_ip
}
