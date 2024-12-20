variable "parent_folder" {
  description = "The ID of the parent folder in the format 'folders/folder_id'"
  type        = string
  default     = "folders/38082493664"
}

variable "env_name" {
  description = "Environment name for the folder"
  type        = string
}

variable "test_mode" {
  description = "Whether to create resources in test mode."
  type        = bool
  default     = true
}

variable "branch_name" {
  description = "The name of the branch to trigger the cloudbuild trigger"
  type        = string
}

variable "artifact_registry_repo_name" {
  description = "The name of the artifact registry repository"
  type        = string
}

variable "mysql_user" {
  description = "The name of the MySQL user to create and to be used by the application"
  type        = string
  default     = "app"
}
