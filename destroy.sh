terraform state rm helm_release.istio_egress
terraform state rm helm_release.istio_ingress
terraform state rm helm_release.istiod
terraform state rm helm_release.istio_base
terraform state rm kubernetes_namespace.istio_system
terraform state rm 'module.eks_cluster.kubernetes_config_map.aws_auth[0]'

terraform destroy --auto-approve