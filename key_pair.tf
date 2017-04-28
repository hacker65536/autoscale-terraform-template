resource "aws_key_pair" "key_pair" {
  key_name_prefix = "${terraform.env}-keypair-"
  public_key      = "${file("${path.cwd}/key_pair.pub")}"
}
