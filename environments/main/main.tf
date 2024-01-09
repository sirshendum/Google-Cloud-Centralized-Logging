# Logs on Spoke Folder & Spoke Projets are sinked to Centralized Log Storage
resource "google_logging_folder_sink" "sink_for_centralized_spoke_logging" {
  name                   = "central-spoke-logging-bucket-sink"
  folder                 =  var.spoke_folder_id
  description            = "Sink for exporting all Spoke Project logs to a logging bucket"
  destination            = format("logging.googleapis.com/projects/%s/locations/%s/buckets/%s", var.hub_logging_project_id, var.logging_bucket_location, var.log_bucket_id)
  include_children       = true
  }

	# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
	resource "google_project_iam_member" "spoke-logbucket-sink-writer" {
	  project = var.hub_logging_project_id
	  role    = "roles/logging.bucketWriter"
	  member  = google_logging_folder_sink.sink_for_centralized_spoke_logging.writer_identity
	}

# Logs on Hub Folder & Hub Projets are sinked to Centralized Log Storage
resource "google_logging_folder_sink" "sink_for_centralized_hub_logging" {
  name                   = "central-hub-logging-bucket-sink"
  folder                 =  var.hub_folder_id
  description            = "Sink for exporting all Hub Project logs to a logging bucket"
  destination            = format("logging.googleapis.com/projects/%s/locations/%s/buckets/%s", var.hub_logging_project_id, var.logging_bucket_location, var.log_bucket_id)
  # filter               = local.base_logging_filter
  include_children       = true
  }

	# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
	resource "google_project_iam_member" "hub-logbucket-sink-writer" {
	  project = var.hub_logging_project_id
	  role    = "roles/logging.bucketWriter"
	  member  = google_logging_folder_sink.sink_for_centralized_hub_logging.writer_identity
	}

# Create a Bucket for backup
resource "google_storage_bucket" "storage-bucket-archive" {
  name                        = var.bucket_cloud_storage_name
  location                    = var.region
  project                     = var.hub_logging_project_id
  storage_class               = "Archive"
  uniform_bucket_level_access = true
 retention_policy {
      is_locked        = var.retention_policy_is_locked
      retention_period = var.retention_policy_retention_period
  }
  }

# Logs requied retention above 365days sinked to Cloud Storage
resource "google_logging_project_sink" "cloud-storage-sink" {
  name        = "cloud-storage-logsink-above365days"
  project     =  var.hub_logging_project_id
  description = "Sink logs to Cloud Storage Archive retention above365days"
  destination = "storage.googleapis.com/${google_storage_bucket.kcns-storage-bucket-archive.name}"
  unique_writer_identity = true
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "cloud-storage-sink-writer" {
  project = var.hub_logging_project_id
  role = "roles/storage.objectCreator"
  members = [
    google_logging_project_sink.cloud-storage-sink.writer_identity
  ]
}
