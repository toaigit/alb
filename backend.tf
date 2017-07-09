terraform {
  backend "s3" {
    bucket = "toai.remotestate.net"
    key    = "toaialb.tfstate"
    region = "us-west-2"
  }
}
