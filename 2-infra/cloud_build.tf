resource "google_service_account" "cloud_build_service_account" {
  account_id   = "cloud-build-sa"
  display_name = "Cloud Build Service Account"
  project      = module.infra_project.project_id
}

locals {
  cloud_build_roles = [
    "roles/cloudbuild.builds.editor",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/compute.instanceAdmin.v1"
  ]
}

resource "google_project_iam_member" "cloud_build_permissions" {
  for_each = toset(local.cloud_build_roles)
  project  = module.infra_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

resource "google_artifact_registry_repository_iam_member" "artifactregistry_repo_writer" {
  project    = local.docker_repo_resource.project
  location   = local.docker_repo_resource.location
  repository = local.docker_repo_resource.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

locals {
  github_pat_secret = data.terraform_remote_state.cicd_state.outputs.secret_manager_github_pat_secret
}

resource "google_secret_manager_secret_iam_member" "cloud_build_sa_secret_accessor" {
  project   = module.infra_project.project_id
  secret_id = local.github_pat_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

resource "google_cloudbuildv2_connection" "my_connection" {
  project  = module.infra_project.project_id
  location = local.common_config.default_region
  name     = "personal_github_connection"

  github_config {
    app_installation_id = "58475400"
    authorizer_credential {
      oauth_token_secret_version = "${local.github_pat_secret.id}/versions/latest"
    }
  }
  depends_on = [google_secret_manager_secret_iam_member.cloud_build_sa_secret_accessor]
}

resource "google_cloudbuildv2_repository" "guithub_repository" {
  project           = module.infra_project.project_id
  location          = local.common_config.default_region
  name              = local.common_config.application_name
  parent_connection = google_cloudbuildv2_connection.my_connection.name
  remote_uri        = local.common_config.github_repository_url
}


resource "google_cloudbuild_trigger" "app_trigger" {
  project  = module.infra_project.project_id
  name     = "app-cicd-${var.env_name}-trigger"
  location = local.common_config.default_region
  disabled = false
  repository_event_config {
    repository = google_cloudbuildv2_repository.guithub_repository.id
    push {
      branch = "^develop$"
    }
  }

  filename        = "app/cloudbuild.yaml"
  service_account = google_service_account.cloud_build_service_account.id

  included_files = ["app/**"]

  substitutions = {
    _IMAGE         = local.docker_image
    _INSTANCE_NAME = local.vm_name
    _ZONE          = local.common_config.default_zone
  }
}

