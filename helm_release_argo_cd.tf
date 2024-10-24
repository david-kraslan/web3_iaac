resource "helm_release" "argo_cd" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo"
  max_history      = 3
  create_namespace = true
  wait             = true
  reset_values     = true
  version          = "7.3.11"

  values = [file("values/argocd.yml")]

  depends_on = [module.eks.eks_managed_node_groups]

}