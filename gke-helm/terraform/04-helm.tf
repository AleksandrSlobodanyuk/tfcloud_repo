
# Init Stable Helm repositary
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}


resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress-test2"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "nginx-ingress"
  version    = "1.34.3"
  
  values = [<<EOF
controller:
  autoscaling:
    enabled: true
    minReplicas: 2
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
  publishService:
    enabled: true
  service:
    loadBalancerIP: ${google_compute_address.nginx-ingress-ip.address}
EOF
  ]
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
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "grafana.service.port"
    value = 3000
  }

  values = [<<EOF
prometheus:
  prometheusSpec:
    additionalScrapeConfigsExternal: true
  additionalServiceMonitors:
  - name: nginx-ingress-service-monitor
    jobLabel: nginx-ingress
    selector:
      matchLabels:
        app: nginx-ingress
        release: nginx-ingress-test2
    namespaceSelector:
      matchNames:
      - default
    endpoints:
    - port: metrics
      interval: 30s
grafana:
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'nginx-ingress'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: true
        editable: true
        options:
          path: /var/lib/grafana/dashboards/nginx-ingress
  dashboards:
    nginx-ingress:
      nginx-ingress-controller:
        datasource: Prometheus
        gnetId: 9614
        revision: 1     
EOF
  ]
}

resource "helm_release" "hash-browns" {
  name       = "hash-browns"
  chart      = "../charts/hash-browns"
}


resource "helm_release" "grafana-dashboards" {
 name      = "grafana-dashboards"
 chart = "../charts/grafana-dashboards"
}