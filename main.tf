resource "null_resource" "example" {
  triggers = {
    a = "2"
  }
}
