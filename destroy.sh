terraform state rm helm_release.istio_egress
terraform state rm helm_release.istio_ingress
terraform state rm helm_release.istiod
terraform state rm helm_release.istio_base
terraform state rm kubernetes_namespace.istio_system

terraform destroy --auto-approve