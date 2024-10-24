resource "kubernetes_namespace" "web3app" {
  metadata {
    name = "web3app"
  }
}