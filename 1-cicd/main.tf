locals {
  env   = "global"
  layer = "cicd"

  required_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}

data "google_folder" "parent_folder" {
  folder = var.parent_folder
}

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  name              = "${var.project_prefix}-${local.layer}"
  random_project_id = true
  folder_id         = data.google_folder.parent_folder.id
  billing_account   = var.billing_account
  create_project_sa = false
  deletion_policy   = var.test_mode ? "DELETE" : "RETAIN"

  activate_apis = local.required_apis

  labels = {
    env   = local.env
    layer = local.layer
  }
}


