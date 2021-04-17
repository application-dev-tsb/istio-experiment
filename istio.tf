
locals {
  istio_namespace = "istio-system"
}

resource "kubernetes_namespace" "istio_system" {

  metadata {
    name = local.istio_namespace
    labels = {
      name = local.istio_namespace
    }
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}

resource "helm_release" "istio_base" {
  provider        = helm.this_cluster
  name            = "istio-base"
  namespace       = local.istio_namespace
  chart           = "${path.module}/istio-1.9.3/manifests/charts/base"
  cleanup_on_fail = true

  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istiod" {
  provider        = helm.this_cluster
  name            = "istiod"
  namespace       = local.istio_namespace
  chart           = "${path.module}/istio-1.9.3/manifests/charts/istio-control/istio-discovery"
  cleanup_on_fail = true

  depends_on = [helm_release.istio_base]
}