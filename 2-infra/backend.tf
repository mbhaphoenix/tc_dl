terraform {
  backend "gcs" {
    bucket = "bkt-tf-state-prj-cicd-1d52"
    prefix = "terraform/infra/state"
  }
}

data "terraform_remote_state" "cicd_state" {
  backend = "gcs"
  config = {
    bucket = "bkt-tf-state-prj-cicd-1d52"
    prefix = "terraform/cicd/state"
  }
}
