resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  version          = "6.57.4"
  max_history      = 3
  create_namespace = false
  wait             = true
  reset_values     = true
  set {
    name  = "adminUser"
    value = "admin"
  }
  set {
    name  = "adminPassword"
    value = "admin"
  }

  depends_on = [helm_release.prometheus_stack]

}