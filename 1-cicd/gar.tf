locals {
  docker_repos_ids = {
    "dev" = "snapshots",
    "prd" = "releases"
  }
}

resource "google_artifact_registry_repository" "docker_repos" {
  for_each = local.docker_repos_ids

  project       = module.project.project_id
  location      = var.default_region
  repository_id = each.value
  description   = "Docker repository for ${each.key} environment"
  format        = "DOCKER"
}
