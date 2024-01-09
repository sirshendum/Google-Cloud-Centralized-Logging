variable "hub_project_id" {
  type        = string
  description = "The hub project ID to host common resourcs."
}

variable "hub_logging_project_id" {
  type        = string
  description = "The project ID for centralized logging project"
  default     = ""
}

#Service Account 
variable "tf_service_account" {
  type = string
  description = "Default Service account"
}

# region Name 
variable "region" {
  type = string
  description = "Default region Name"
}

variable "spoke_folder_id" {
  type        = string
  description = "The Spoke Folder ID for centralized logging."
  default     = ""
}

variable "hub_folder_id" {
  type        = string
  description = "The Hub Folder ID for centralized logging."
  default     = ""
}

variable "logging_bucket_location" {
  description = "The location of the logging bucket"
  type        = string
  default     = "global"
}

variable "log_bucket_id" {
  description = "The ID of the logging bucket"
  type        = string
}

variable "bucket_cloud_storage_name" {
  description = "The ID of the cloud storage bucket"
  type        = string
}

variable "retention_policy_is_locked" {
  description = "Retention Policy for bucket locked permanently restrict"
  type        = string
  default     = "false"
}

variable "retention_policy_retention_period" {
  description = "The period of time, in seconds, that objects in the bucket must be retained "
  type        = string
}