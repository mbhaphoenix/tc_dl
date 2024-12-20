locals {
  layer                = "infra"
  common_config        = data.terraform_remote_state.cicd_state.outputs.common_config
  docker_repo_resource = data.terraform_remote_state.cicd_state.outputs.docker_repos[var.env_name]
  docker_repo          = "${local.docker_repo_resource.location}-docker.pkg.dev/${local.docker_repo_resource.project}/${local.docker_repo_resource.repository_id}"
  docker_image         = "${local.docker_repo}/${local.common_config.application_name}"

  #"{_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY}/${_IMAGE}"



  required_apis = [
    "compute.googleapis.com",           # For VPC and VM instances
    "servicenetworking.googleapis.com", # For private services
    "sqladmin.googleapis.com",          # For Cloud SQL
    "storage.googleapis.com",           # For Cloud Storage
    "iam.googleapis.com",               # For IAM
    "artifactregistry.googleapis.com",  # For Artifact Registry
    "secretmanager.googleapis.com",     # For Secret Manager
    "cloudbuild.googleapis.com",        # For Cloud Build
  ]
}


resource "google_folder" "env_folder" {
  display_name = "${local.common_config.folder_prefix}-${var.env_name}"
  parent       = var.parent_folder
}

# Create infrastructure project
module "infra_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  name              = "${local.common_config.project_prefix}-${local.layer}-${var.env_name}"
  random_project_id = true
  folder_id         = google_folder.env_folder.name
  billing_account   = local.common_config.billing_account

  activate_apis = local.required_apis

  create_project_sa = false

  labels = {
    env   = var.env_name
    layer = local.layer
  }

  deletion_policy = var.test_mode ? "DELETE" : "RETAIN"
}


