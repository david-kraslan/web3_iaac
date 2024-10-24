data "aws_iam_policy_document" "argo_cd_image_updater" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "argo_cd_image_updater" {
  name               = "${module.eks.cluster_name}-argocd-image-updater"
  assume_role_policy = data.aws_iam_policy_document.argo_cd_image_updater.json
}

resource "aws_iam_role_policy_attachment" "argo_cd_image_updater" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.argo_cd_image_updater.name
}

resource "aws_eks_pod_identity_association" "argo_cd_image_updater" {
  cluster_name    = module.eks.cluster_name
  namespace       = "argo"
  service_account = "argocd-image-updater"
  role_arn        = aws_iam_role.argo_cd_image_updater.arn
}

resource "helm_release" "argo_cd_image_updater" {
  name = "updater"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  namespace  = "argo"
  version    = "0.11.0"

  values = [file("values/argo-cd-image-updater.yml")]

  depends_on = [helm_release.argo_cd]

}