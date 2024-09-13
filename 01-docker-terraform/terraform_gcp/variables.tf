variable "credentials" {
  description = "My credentials"
  default     = "./keys/ariel_gcp.json"
}

variable "project" {
  description = "Project"
  default     = "i-matrix-435319-g3"
}

variable "region" {
  description = "Project Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "ny_taxi"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "i-matrix-435319-g3-ds-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
