resource "kubernetes_namespace" "nginx-dev" {
  metadata {
    name = "nginx-dev"
  }
}

resource "kubernetes_namespace" "nginx-test" {
  metadata {
    name = "nginx-test"
  }
}

module "nginx-controller-dev" {
  source                   = "terraform-iaac/nginx-controller/helm"
  version                  = "2.3.0"
  namespace                = "nginx-dev"
  ingress_class_name       = "nginx-dev"
  ingress_class_is_default = false

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

  depends_on = [kubernetes_namespace.nginx-dev]
}

module "nginx-controller-test" {
  source                   = "terraform-iaac/nginx-controller/helm"
  version                  = "2.3.0"
  namespace                = "nginx-test"
  ingress_class_name       = "nginx-test"
  ingress_class_is_default = false

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

  depends_on = [kubernetes_namespace.nginx-test]
}

resource "kubernetes_cluster_role" "ingress_nginx_role" {
  metadata {
    name = "ingress-nginx-role"
  }

  rule {
    api_groups = [""]
    resources  = ["secrets", "services", "endpoints", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["get", "list", "watch"]
  }
}

# Binding for nginx-dev namespace
resource "kubernetes_cluster_role_binding" "ingress_nginx_role_binding_dev" {
  metadata {
    name = "ingress-nginx-role-binding-dev"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ingress_nginx_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = kubernetes_namespace.nginx-dev.metadata[0].name
  }

  depends_on = [kubernetes_namespace.nginx-dev]
}

# Binding for nginx-test namespace
resource "kubernetes_cluster_role_binding" "ingress_nginx_role_binding_test" {
  metadata {
    name = "ingress-nginx-role-binding-test"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ingress_nginx_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ingress-nginx"
    namespace = kubernetes_namespace.nginx-test.metadata[0].name
  }

  depends_on = [kubernetes_namespace.nginx-test]
}
