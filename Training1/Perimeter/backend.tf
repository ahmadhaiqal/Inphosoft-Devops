terraform {
  backend "s3" {
    bucket = "terraform-inphosoft-state-ahmad"
    key    = "training1/perimeter/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

