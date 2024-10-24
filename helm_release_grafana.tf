resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  version          = "6.29.1"
  max_history      = 3
  create_namespace = false
  wait             = true
  reset_values     = true

  depends_on = [helm_release.prometheus_stack]

}