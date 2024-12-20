# `2-infra` Directory

This directory contains infrastructure as code for deploying the fast_api application and its dependencies.

## Structure

Take a look at the architecture diagam to have a googe grasp on the components deployed.

The tf state (running `terraform state list`) would look like this.

```bash
data.terraform_remote_state.cicd_state
google_artifact_registry_repository_iam_member.artifactregistry_repo_reader
google_artifact_registry_repository_iam_member.artifactregistry_repo_writer
google_cloudbuild_trigger.app_trigger
google_cloudbuildv2_connection.my_connection
google_cloudbuildv2_repository.guithub_repository
google_compute_firewall.allow_http
google_compute_firewall.allow_iap_ssh
google_compute_firewall.allow_mysql_internal
google_compute_firewall.allow_ssh
google_compute_global_address.private_ip_address
google_compute_instance.vm
google_folder.env_folder
google_project_iam_member.cloud_build_permissions["roles/cloudbuild.builds.editor"]
google_project_iam_member.cloud_build_permissions["roles/compute.instanceAdmin.v1"]
google_project_iam_member.cloud_build_permissions["roles/iam.serviceAccountUser"]
google_project_iam_member.cloud_build_permissions["roles/logging.logWriter"]
google_project_iam_member.vm_sa_logging_writer_role
google_project_iam_member.vm_sa_roles["roles/cloudsql.client"]
google_project_iam_member.vm_sa_roles["roles/cloudsql.instanceUser"]
google_project_iam_member.vm_sa_roles["roles/secretmanager.secretAccessor"]
google_secret_manager_secret_iam_member.cloud_build_serviceagent_secret_accessor
google_service_account.cloud_build_service_account
google_service_account.vm_service_account
google_service_networking_connection.private_vpc_connection
google_storage_bucket_iam_member.vm_storage_access
google_storage_bucket_object.initial_data["clients.csv"]
google_storage_bucket_object.initial_data["products.csv"]
random_password.mysql_password
module.data_bucket.data.google_storage_project_service_account.gcs_account
module.data_bucket.google_storage_bucket.bucket
module.gce-container.data.google_compute_image.coreos
module.mysql.google_sql_database.default[0]
module.mysql.google_sql_database_instance.default
module.mysql.google_sql_user.default[0]
module.mysql.null_resource.module_depends_on
module.mysql.random_id.suffix[0]
module.mysql.random_password.user-password[0]
module.secret_manager_mysq_password_secret.google_secret_manager_secret.secret
module.secret_manager_mysq_password_secret.google_secret_manager_secret_version.version
module.infra_project.module.project-factory.google_project.main
module.infra_project.module.project-factory.google_project_default_service_accounts.default_service_accounts[0]
module.infra_project.module.project-factory.random_id.random_project_id_suffix
module.vpc.module.subnets.google_compute_subnetwork.subnetwork["europe-west1/infra-private-subnet"]
module.vpc.module.vpc.google_compute_network.network
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["artifactregistry.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["cloudbuild.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["compute.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["iam.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["secretmanager.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["servicenetworking.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["sqladmin.googleapis.com"]
module.infra_project.module.project-factory.module.project_services.google_project_service.project_services["storage.googleapis.com"]
```