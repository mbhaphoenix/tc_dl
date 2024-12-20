output "infra_project_id" {
  description = "The ID of the project"
  value       = module.infra_project.project_id
}

output "vm_instance_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.vm.name
}

output "vm_internal_ip" {
  description = "The internal IP of the VM instance"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "vm_service_account" {
  description = "The service account email of the VM"
  value       = google_service_account.vm_service_account.email
}

output "mysql_instance_name" {
  description = "The name of the MySQL instance"
  value       = module.mysql.instance_name
}


output "mysql_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = module.mysql.instance_connection_name
}

output "mysql_db_name" {
  description = "The name of the MySQL database"
  value       = local.common_config.application_name
}

output "mysql_user" {
  description = "The MySQL user name"
  value       = var.mysql_user
}

output "mysql_private_ip" {
  description = "The private IP of the MySQL instance"
  value       = module.mysql.private_ip_address
}
