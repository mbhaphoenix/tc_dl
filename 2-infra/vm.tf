# Create a service account for the VM
locals {
  vm_name = "vm-${var.env_name}"
}

resource "google_service_account" "vm_service_account" {
  project      = module.infra_project.project_id
  account_id   = "vm-sa-${var.env_name}"
  display_name = "Service Account for ${var.env_name} VM"
}

# Grant required roles to the VM service account
resource "google_project_iam_member" "vm_sa_roles" {
  for_each = toset([
    "roles/secretmanager.secretAccessor", # To access secrets
    "roles/cloudsql.client",              # To connect to Cloud SQL
    "roles/cloudsql.instanceUser",        # To access Cloud SQL instances
  ])

  project = module.infra_project.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.vm_service_account.email}"
}

resource "google_artifact_registry_repository_iam_member" "artifactregistry_repo_reader" {
  project    = local.docker_repo_resource.project
  location   = local.docker_repo_resource.location
  repository = local.docker_repo_resource.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.vm_service_account.email}"
}


# Grant VM service account access to GCS data bucket
resource "google_storage_bucket_iam_member" "vm_storage_access" {
  bucket = module.data_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.vm_service_account.email}"
}

# Assign the IAM role roles/logging.logWriter to the VM service account
resource "google_project_iam_member" "vm_sa_logging_writer_role" {
  project = module.infra_project.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.vm_service_account.email}"
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.2"

  container = {
    image = "${local.docker_image}:latest"
    env = [
      {
        name  = "DB_HOST"
        value = module.mysql.private_ip_address
      },
      {
        name  = "DB_USER"
        value = var.mysql_user
      },
      {
        name  = "DB_PASSWORD_SECRET_ID"
        value = module.secret_manager_mysq_password_secret.name
      },
      {
        name  = "DB_NAME"
        value = local.common_config.application_name
      },
      {
        name  = "DB_CONNECTION_NAME"
        value = module.mysql.instance_connection_name
      },
      {
        name  = "DATA_BUCKET_NAME"
        value = module.data_bucket.name
      }
    ]
  }
  restart_policy = "Always"
}

# Create a compute instance with Container-Optimized OS
resource "google_compute_instance" "vm" {
  project      = module.infra_project.project_id
  name         = local.vm_name
  machine_type = "g1-small"
  zone         = local.common_config.default_zone

  # Add tags for firewall rules
  tags = ["http-server", "ssh"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = 10
    }
  }

  network_interface {
    network    = module.vpc.network_id
    subnetwork = module.vpc.subnets["${local.common_config.default_region}/${local.layer}-private-subnet"].id
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    google-logging-enabled    = true
    enable-oslogin            = var.test_mode ? "TRUE" : "FALSE"
    gce-container-declaration = module.gce-container.metadata_value
  }

  labels = {
    env   = var.env_name
    layer = local.layer
  }

  # Ensure the instance has access to secrets before starting
  depends_on = [
    google_project_iam_member.vm_sa_roles
  ]
}
