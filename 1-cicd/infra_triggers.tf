resource "google_cloudbuild_trigger" "infra_tf_plan_trigger" {
  project  = module.project.project_id
  name     = "infra-tf-plan-trigger"
  location = var.default_region
  disabled = false
  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repository.id
    push {
      branch = "^develop$"
    }
  }

  filename        = "1-cicd/build-conf-files-infra/cloudbuild.tf.plan.ws.yaml"
  service_account = google_service_account.cloud_build_service_account.id

  included_files = ["2-infra/**"]

  substitutions = {
    _TERRAFORM_VERSION = var.terraform_version
    _BUILD_DIR         = "2-infra"
    _TF_WORKSPACE      = "dev"
    _TF_STATE_BUCKET   = module.tf_state_bucket.name
  }
}

resource "google_cloudbuild_trigger" "infra_tf_apply_trigger" {
  project  = module.project.project_id
  name     = "infra-tf-apply-trigger"
  location = var.default_region
  disabled = true
  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repository.id
    push {
      branch = "^develop$"
    }
  }


  filename        = "1-cicd/build-conf-files-infra/cloudbuild.tf.apply.ws.yaml"
  service_account = google_service_account.cloud_build_service_account.id

  included_files = ["2-infra/**"]

  substitutions = {
    _TERRAFORM_VERSION = var.terraform_version
    _BUILD_DIR         = "2-infra"
    _TF_WORKSPACE      = "dev"
    _TF_STATE_BUCKET   = module.tf_state_bucket.name
  }
}