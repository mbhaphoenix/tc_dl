locals {
  cloud_build_sa_roles = [
    "roles/viewer",
    "roles/cloudbuild.builds.editor",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/secretmanager.secretAccessor",
  ]
}

resource "google_service_account" "cloud_build_service_account" {
  account_id   = "cloud-build-sa"
  display_name = "Cloud Build Service Account"
  project      = module.project.project_id
}

resource "google_folder_iam_member" "doctolib_folder_permissions" {
  for_each = toset([
    "roles/iam.securityReviewer",
    "roles/browser",
    "roles/resourcemanager.projectCreator",
    "roles/editor",
    "roles/secretmanager.secretAccessor"
  ])
  folder = var.parent_folder
  role   = each.value
  member = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

resource "google_project_iam_member" "cloud_build_permissions" {
  for_each = toset(local.cloud_build_sa_roles)
  project  = module.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = module.tf_state_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

resource "google_secret_manager_secret_iam_member" "cloud_build_sa_secret_accessor" {
  project   = module.project.project_id
  secret_id = google_secret_manager_secret.github_pat_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_build_service_account.email}"
}

resource "google_cloudbuildv2_connection" "github_connection" {
  project  = module.project.project_id
  location = var.default_region
  name     = "personal_github_connection"

  github_config {
    app_installation_id = "58475400"
    authorizer_credential {
      oauth_token_secret_version = "${google_secret_manager_secret.github_pat_secret.id}/versions/latest"
    }
  }
  depends_on = [google_secret_manager_secret_iam_member.cloud_build_sa_secret_accessor]
}

resource "google_cloudbuildv2_repository" "github_repository" {
  project           = module.project.project_id
  location          = var.default_region
  name              = var.repository_name
  parent_connection = google_cloudbuildv2_connection.github_connection.name
  remote_uri        = var.repository_url
}


