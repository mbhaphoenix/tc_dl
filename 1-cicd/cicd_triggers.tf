resource "google_cloudbuild_trigger" "cicd_tf_plan_trigger" {
  project  = module.project.project_id
  name     = "cicd-tf-plan-trigger"
  location = var.default_region
  disabled = false
  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repository.id
    push {
      branch = "^develop$"
    }
  }

  filename        = "1-cicd/build-conf-files-cicd/cloudbuild.tf.plan.yaml"
  service_account = google_service_account.cloud_build_service_account.id

  included_files = ["1-cicd/**"]

  substitutions = {
    _TERRAFORM_VERSION = var.terraform_version
    _BUILD_DIR         = "1-cicd"
    _TF_STATE_BUCKET   = module.tf_state_bucket.name
  }
}

resource "google_cloudbuild_trigger" "cicd_tf_apply_trigger" {
  project  = module.project.project_id
  name     = "cicd-tf-apply-trigger"
  location = var.default_region
  disabled = true
  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repository.id
    push {
      branch = "^develop$"
    }
  }


  filename        = "1-cicd/build-conf-files-cicd/cloudbuild.tf.apply.yaml"
  service_account = google_service_account.cloud_build_service_account.id

  included_files = ["1-cicd/**"]

  substitutions = {
    _TERRAFORM_VERSION = var.terraform_version
    _BUILD_DIR         = "1-cicd"
    _TF_STATE_BUCKET   = module.tf_state_bucket.name
  }
}