module "data_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 8.0"

  project_id    = module.infra_project.project_id
  name          = "${local.common_config.bucket_prefix}-${module.infra_project.project_id}-data"
  location      = local.common_config.default_region_gcs
  storage_class = "STANDARD"
  force_destroy = var.test_mode
  versioning    = false

  labels = {
    env   = var.env_name
    layer = local.layer
  }
}

resource "google_storage_bucket_object" "initial_data" {
  for_each = fileset("${path.module}/data", "*.csv")

  name   = "data/${each.value}"
  bucket = module.data_bucket.name
  source = "${path.module}/data/${each.value}"
}
