resource "null_resource" "example" {
  triggers = {
    a = "1"
  }
}
resource "aws_s3_bucket" "broken" {
  not_a_real_argument = 1
}
