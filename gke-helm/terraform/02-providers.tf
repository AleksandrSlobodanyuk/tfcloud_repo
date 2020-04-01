# Configure Google Cloud Storage bucket as TFSTATE backend
terraform {
  backend "gcs" {
    bucket      = "gke-bucket-55"
    prefix      = "k8app/state"
    credentials = "../k8s-svc.json"
  }
}

# Configure the Google Cloud provider
provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_location
  zone        = var.zone-1
  credentials = var.service_account_key
}

# Configure the Google Cloud beta provider
provider "google-beta" {
  project     = var.gcp_project_id
  region      = var.region
  zone        = var.zone-1
  credentials = var.service_account_key
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }

}
# Enable services in newly created GCP Project.
resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  service = each.key
  project = var.gcp_project_id
  disable_on_destroy = false
}

data "google_project" "project" {
}
