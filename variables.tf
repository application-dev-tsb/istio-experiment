variable "org" {
  description = "Name of the Organization"
  type        = string
  default     = "istio"
}

variable "env" {
  description = "Name of the Environment"
  type        = string
  default     = "experiment"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default = "172.30.0.0/16"
}

variable "vpc_public_cidrs" {
  description = "CIDR for public Subnet"
  type        = list(string)
  default = ["172.30.0.0/20", "172.30.16.0/20", "172.30.32.0/20"]
}

variable "vpc_private_cidrs" {
  description = "CIDR for private Subnet"
  type        = list(string)
  default = ["172.30.128.0/20", "172.30.144.0/20", "172.30.160.0/20"]
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default = "istio-experiment-eks"
}