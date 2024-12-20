resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "secret_manager_mysq_password_secret" {
  source  = "GoogleCloudPlatform/secret-manager/google//modules/simple-secret"
  version = "~> 0.5"

  project_id = module.infra_project.project_id

  name        = "mysql-user-password-${var.env_name}"
  secret_data = random_password.mysql_password.result

  labels = {
    env   = var.env_name
    layer = local.layer
  }
}

