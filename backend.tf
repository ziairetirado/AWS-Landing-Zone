terraform {
  backend "s3" {
    bucket = "secure-landing-zone-state2"
    key    = "global/terraform.tfstate"
    region = "us-east-1"
  }
}