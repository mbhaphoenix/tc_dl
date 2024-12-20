# Create private service networking connection
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_id
  project       = module.infra_project.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

module "mysql" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 23.0"

  name                 = "mysql-${var.env_name}"
  random_instance_name = true
  project_id           = module.infra_project.project_id
  database_version     = "MYSQL_8_0"
  region               = local.common_config.default_region

  deletion_protection = !var.test_mode

  # Instance configuration
  tier              = "db-f1-micro" # Smallest instance for testing
  availability_type = "REGIONAL"
  zone              = local.common_config.default_zone

  db_name = local.common_config.application_name


  # Network configuration
  ip_configuration = {
    ipv4_enabled        = false
    private_network     = module.vpc.network_id
    require_ssl         = true
    allocated_ip_range  = google_compute_global_address.private_ip_address.name
    authorized_networks = []
  }

  # Database configuration
  database_flags = [
    {
      name  = "max_connections"
      value = "100"
    }
  ]

  # User configuration
  user_name     = var.mysql_user
  user_password = random_password.mysql_password.result

  depends_on = [google_service_networking_connection.private_vpc_connection]
}
