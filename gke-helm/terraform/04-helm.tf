

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}


resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress-test2"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "nginx-ingress"
  version    = "1.34.3"
  
  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.nginx-ingress-ip.address
  }

  set {
    name  = "controller.autoscaling.enabled"
    value = true
  }

  set {
    name  = "controller.autoscaling.minReplicas"
    value = 2
  }

  set {
    name  = "controller.metrics.enabled"
    value = true
  } 

  set {
    name  = "controller.stats.enabled"
    value = true
  }

} 

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "prometheus-operator"
 
  set {
    name  = "prometheus.service.loadBalancerIP"
    value = google_compute_address.nginx-ingress-ip.address
  }

  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer"
  } 

  set {
    name  = "alertmanager.service.loadBalancerIP"
    value = google_compute_address.nginx-ingress-ip.address
  }

  set {
    name  = "alertmanager.service.type"
    value = "LoadBalancer"
  }

    set {
    name  = "grafana.service.loadBalancerIP"
    value = google_compute_address.nginx-ingress-ip.address
  }

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  } 

}

resource "helm_release" "hello-app" {
  name       = "hello-app"
  chart      = "../charts/hello-app"
}