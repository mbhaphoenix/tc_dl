# Allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  project = module.infra_project.project_id
  name    = "allow-http-${var.env_name}"
  network = module.vpc.network_id

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Allow internal MySQL access
resource "google_compute_firewall" "allow_mysql_internal" {
  project = module.infra_project.project_id
  name    = "allow-mysql-internal-${var.env_name}"
  network = module.vpc.network_id

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  # Only allow traffic from the VM's subnet to MySQL
  source_ranges = [module.vpc.subnets["${local.common_config.default_region}/${local.layer}-private-subnet"].ip_cidr_range]
  target_tags   = ["mysql"]
}

# Allow direct SSH access
resource "google_compute_firewall" "allow_ssh" {
  project = module.infra_project.project_id
  name    = "allow-ssh-${var.env_name}"
  network = module.vpc.network_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Replace with your trusted IP ranges
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# Allow IAP SSH access
resource "google_compute_firewall" "allow_iap_ssh" {
  project = module.infra_project.project_id
  name    = "allow-iap-ssh-${var.env_name}"
  network = module.vpc.network_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # IAP's IP range
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh"]
}


