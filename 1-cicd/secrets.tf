# Create a secret containing the personal access token and grant permissions to the Service Agent
resource "google_secret_manager_secret" "github_pat_secret" {
  project   = module.project.project_id
  secret_id = "github_pat"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret      = google_secret_manager_secret.github_pat_secret.id
  secret_data = "fake"
}
