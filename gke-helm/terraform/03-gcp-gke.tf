resource "google_compute_address" "nginx-ingress-ip" {
  name = "k8app-cluster-nginx-ingress-controller"
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = "false"
  project                 = var.gcp_project_id
}


resource "google_compute_subnetwork" "vpc_subnetwork" {
  name = var.vpc_subnetwork_name
  ip_cidr_range = var.vpc_subnetwork_cidr_range
  network = var.vpc_network_name

  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cluster_secondary_range_cidr
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.services_secondary_range_cidr
  }

  private_ip_google_access = true

  depends_on = [
    google_compute_network.vpc_network
  ]
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.gcp_project_id
  name                       = var.cluster_name
  region                     = var.gcp_location
  zones                      = ["us-central1-a"]
  network                    = google_compute_network.vpc_network.name
  subnetwork                 = google_compute_subnetwork.vpc_subnetwork.name
  ip_range_pods              = var.cluster_secondary_range_name
  ip_range_services          = var.services_secondary_range_name
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 1
      max_count          = 6
      local_ssd_count    = 0
      disk_size_gb       = 60
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

resource "null_resource" "kube_config" {
  depends_on = [module.gke]
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
gcloud container clusters get-credentials ${var.cluster_name} --region=${var.gcp_location} --project ${var.gcp_project_id}
sleep 5
LOCAL_EXEC
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}