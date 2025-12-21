data "aws_ami" "ami_id" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu*"] #steps
  }
  filter {
    name   = "virtualization-type" #steps
    values = ["hvm"] #steps
  }
  owners = ["099720109477"] #steps
}

output "instance_id" {
  description = "Id of ami"
  value       = data.aws_ami.ami_id.id
}

#refer steps to understand how to get these details