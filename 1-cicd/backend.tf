# Initially comment this out until the bucket is created
terraform {
  backend "gcs" {
    bucket = "bkt-tf-state-prj-cicd-1d52"
    prefix = "terraform/cicd/state"
  }
}