#!/bin/bash
gcloud config set project test-k8s-272906
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com