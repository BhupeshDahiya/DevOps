resource "aws_key_pair" "tf-key" {
  key_name   = "Tf-key"
  public_key = "ssh-rsa Pub_key_values"
}

# create a key using ssh-keygen (optional -t rsa) and replace the key name and public part here 