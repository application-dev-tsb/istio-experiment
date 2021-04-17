data "aws_caller_identity" "current" {}

module "eks_cluster" {
  source           = "terraform-aws-modules/eks/aws"
  cluster_name     = var.eks_cluster_name
  vpc_id           = aws_vpc.vpc.id
  subnets          = aws_subnet.private_subnet.*.id
  write_kubeconfig = false
  cluster_version  = "1.19"
  manage_aws_auth  = true

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  map_accounts = [data.aws_caller_identity.current.account_id]

  node_groups_defaults = {
    desired_capacity = 1
    min_capacity     = 1
  }

  node_groups = [
    {
      name           = "${var.eks_cluster_name}-worker-on-demand"
      capacity_type  = "ON_DEMAND"
      instance_types = ["c5.large"]
      max_capacity   = 2

      additional_tags = {
        Name = "${var.eks_cluster_name}-worker-on-demand"
      }
    },

    {
      name           = "${var.eks_cluster_name}-worker-spot"
      capacity_type  = "SPOT"
      instance_types = ["r5.2xlarge"]
      max_capacity   = 40

      additional_tags = {
        Name = "${var.eks_cluster_name}-worker-spot"
      }
    }
  ]

  worker_create_security_group  = false
  cluster_create_security_group = false

}

resource "aws_iam_role_policy_attachment" "cluster_AWSXRayDaemonWriteAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = module.eks_cluster.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = module.eks_cluster.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = module.eks_cluster.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_CloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = module.eks_cluster.worker_iam_role_name
}