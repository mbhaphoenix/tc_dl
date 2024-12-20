variable "parent_folder" {
  description = "The ID of the parent folder in the format 'folders/folder_id'"
  type        = string
  default     = "folders/569617559038"
}

variable "billing_account" {
  description = "The ID of the billing account"
  type        = string
  default     = "016C12-6C4839-5B293E"
}

variable "folder_prefix" {
  description = "Name prefix to use for folders to create"
  type        = string
  default     = "fld"
}

variable "project_prefix" {
  description = "Name prefix to use for projects to create"
  type        = string
  default     = "prj"
}

variable "bucket_prefix" {
  description = "Name prefix to use for buckets to create"
  type        = string
  default     = "bkt"
}

variable "default_region" {
  description = "The default region for resources"
  type        = string
  default     = "europe-west1"
}

variable "default_zone" {
  description = "The default zone for resources"
  type        = string
  default     = "europe-west1-b"
}

variable "default_region_gcs" {
  description = "The default region for gcs resources"
  type        = string
  default     = "EU"
}

variable "test_mode" {
  description = "Whether to create resources in test mode."
  type        = bool
  default     = true
}

variable "repository_url" {
  description = "The HTTPS clone URL of the repository, ending with .git."
  type        = string
}

variable "repository_name" {
  description = "The name of the github repository and the name to be used for the application different resources."
  type        = string
}

variable "terraform_version" {
  description = "The version of the terraform to be used."
  type        = string
  default     = "1.10.2"
}
