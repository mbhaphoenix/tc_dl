# `1-cicd` Directory

This directory contains infrastructure as code for setting up continuous integration and continuous deployment (CI/CD) pipelines for the whole project.

## Usage

To deploy the `prj-cicd` under a parent_folder specified in the `variables.tf` file. CI/CD infrastructure, run the following Terraform commands:

### First run
1- Athenticate to gcloud using `gcloud auth login` and `and gcloud auth application-default login`. Your used should have the right IAM roles on the parent_folder specified in the `variables.tf` file.
2- comment `backend.tf`
3- Run the following commands. 
```bash
terraform init
terraform apply
```
4- It will fail, You need to add your github PAT as a new version the secret_manager_guithub_secret.

### Second run
1- uncomment `backend.tf`
2- Run the following command. 
```bash
terraform init
```
3- Accept when terraform propose to migrate tje state to Google Cloud Storage bucket. 

### Third run 
The tf state (running `terraform state list`) would look like this.

```bash
data.google_folder.parent_folder
google_artifact_registry_repository.docker_repos["dev"]
google_artifact_registry_repository.docker_repos["prd"]
google_cloudbuild_trigger.cicd_tf_apply_trigger
google_cloudbuild_trigger.cicd_tf_plan_trigger
google_cloudbuild_trigger.infra_tf_apply_trigger
google_cloudbuild_trigger.infra_tf_plan_trigger
google_cloudbuildv2_connection.github_connection
google_cloudbuildv2_repository.github_repository
google_folder_iam_member.doctolib_folder_permissions["roles/browser"]
google_folder_iam_member.doctolib_folder_permissions["roles/editor"]
google_folder_iam_member.doctolib_folder_permissions["roles/iam.securityReviewer"]
google_folder_iam_member.doctolib_folder_permissions["roles/resourcemanager.projectCreator"]
google_project_iam_member.cloud_build_permissions["roles/cloudbuild.builds.editor"]
google_project_iam_member.cloud_build_permissions["roles/iam.serviceAccountUser"]
google_project_iam_member.cloud_build_permissions["roles/logging.logWriter"]
google_project_iam_member.cloud_build_permissions["roles/secretmanager.secretAccessor"]
google_project_iam_member.cloud_build_permissions["roles/viewer"]
google_secret_manager_secret.github_pat_secret
google_secret_manager_secret_iam_member.cloud_build_sa_secret_accessor
google_secret_manager_secret_version.github_token_secret_version
google_service_account.cloud_build_service_account
google_storage_bucket_iam_member.member
module.tf_state_bucket.data.google_storage_project_service_account.gcs_account
module.tf_state_bucket.google_storage_bucket.bucket
module.project.module.project-factory.google_project.main
module.project.module.project-factory.google_project_default_service_accounts.default_service_accounts[0]
module.project.module.project-factory.random_id.random_project_id_suffix
module.project.module.project-factory.module.project_services.google_project_service.project_services["artifactregistry.googleapis.com"]
module.project.module.project-factory.module.project_services.google_project_service.project_services["cloudbuild.googleapis.com"]
module.project.module.project-factory.module.project_services.google_project_service.project_services["cloudresourcemanager.googleapis.com"]
module.project.module.project-factory.module.project_services.google_project_service.project_services["iam.googleapis.com"]
module.project.module.project-factory.module.project_services.google_project_service.project_services["secretmanager.googleapis.com"]
module.project.module.project-factory.module.project_services.google_project_service.project_services["serviceusage.googleapis.com"]
module.project.module.project-factory.module.project_services.google_project_service.project_services["storage.googleapis.com"]
```
