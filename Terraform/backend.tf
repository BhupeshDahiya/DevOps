# file to maintain the tf state file in a s3 bucket, as it is not recommended to maintain it in any VCS
terraform {
  backend "s3" {
    bucket = "buck-for-tf-states"
    key    = "terraformstate/state" # foldername/filename
    region = "us-east-1"
  }
}