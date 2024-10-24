resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

module "nginx-controller" {
  source    = "terraform-iaac/nginx-controller/helm"
  version   = "2.3.0"
  namespace = "nginx"

  additional_set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
      type  = "string"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
      value = "true"
      type  = "string"
    }
  ]

  depends_on = [kubernetes_namespace.nginx]
}