module "tf_state_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 8.0"

  depends_on = [
    module.project # Add explicit dependency on project creation
  ]

  project_id    = module.project.project_id
  name          = "${var.bucket_prefix}-tf-state-${module.project.project_id}"
  location      = var.default_region_gcs
  storage_class = "STANDARD"
  force_destroy = var.test_mode
  versioning    = true

  labels = {
    env   = local.env
    layer = local.layer
  }
}
