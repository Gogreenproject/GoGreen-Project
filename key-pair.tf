#key_pair
resource "aws_key_pair" "key" {
  key_name   = "$Gogreen-key"
  public_key = file("~/.ssh/id_rsa.pub")
}







