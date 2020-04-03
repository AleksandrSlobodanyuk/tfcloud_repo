variable "gcp_project_id" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = "gke-test-272906"
}

variable "service_account_key" {
  type    = string
  default = "../k8s-svc.json"
}

variable "gcp_location" {
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable "zone-1" {
  description = "Region for cloud resources."
  default     = "us-central1-a"
}

variable "suffix" {
  type    = string
  default = "k8app"
}

variable "gcp_service_list" {
  description = "List of GCP service to be enabled for a project."
  type        = list
  default = ["storage-api.googleapis.com","cloudresourcemanager.googleapis.com","compute.googleapis.com","container.googleapis.com","iam.googleapis.com"]
}


variable  "cluster_name" {
   default = "my-cluster"
}   


variable "daily_maintenance_window_start_time" {
  default = "03:00"
} 


variable "vpc_network_name" {
  default = "vpc-network"
}

variable "vpc_subnetwork_name" {
  default = "vpc-subnetwork"
} 

variable "vpc_subnetwork_cidr_range" {
  default = "10.0.16.0/20"
} 

variable "cluster_secondary_range_name" {
  default = "pods"
} 

variable "cluster_secondary_range_cidr" {
  default = "10.16.0.0/12"
} 

variable "services_secondary_range_name" {
  default = "services"
} 

variable "services_secondary_range_cidr" {
  default = "10.1.0.0/20"
} 

variable "master_ipv4_cidr_block" {
  default = "172.16.0.0/28"
} 

variable "access_private_images" {
  default = "false"
} 

variable "http_load_balancing_disabled" {
  default = "false"
} 

variable "master_authorized_networks_cidr_blocks" {
  default = [
  {
    cidr_block = "0.0.0.0/0"

    display_name = "default"
  },
]
}
