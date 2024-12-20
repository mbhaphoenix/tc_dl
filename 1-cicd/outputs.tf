output "cicd_project_id" {
  description = "Project id where cicd will be bootstrapped."
  value       = module.project.project_id
}

output "common_config" {
  description = "Common configuration data to be used in other layers."
  value = {
    billing_account       = var.billing_account,
    default_region        = var.default_region,
    default_zone          = var.default_zone,
    default_region_gcs    = var.default_region_gcs,
    folder_prefix         = var.folder_prefix
    project_prefix        = var.project_prefix,
    bucket_prefix         = var.bucket_prefix
    application_name      = var.repository_name
    github_repository_url = var.repository_url
  }
}

output "secret_manager_github_pat_secret" {
  description = "Guithub PAT secret"
  value       = google_secret_manager_secret.github_pat_secret
}

output "docker_repos" {
  description = "Docker repositories"
  value       = google_artifact_registry_repository.docker_repos
}


