# variables.tf
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "node_count_expected" {
  description = "Expected number of nodes for validation"
  type        = number
  default     = 5
}

variable "network_name_expected" {
  description = "Expected network name"
  type        = string
  default     = "prod-network"
}