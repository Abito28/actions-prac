terraform {
  backend "s3" {
    bucket       = "tfstate-292967571286-actions-prac"
    key          = "actions-prac/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}