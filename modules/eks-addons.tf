data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_blueprints.eks_cluster_id

}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token            
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  }
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  apply_retry_count      = 15
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_eks_addon_version" "latest" {
  for_each = toset(["vpc-cni"])

  addon_name         = each.value
  kubernetes_version = var.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name         = module.eks_blueprints.eks_cluster_id
  addon_name           = "vpc-cni"
  addon_version        = data.aws_eks_addon_version.latest["vpc-cni"].version
  resolve_conflicts    = "OVERWRITE"
  configuration_values = "{\"env\":{\"ENABLE_PREFIX_DELEGATION\":\"true\", \"ENABLE_POD_ENI\":\"true\"}}"
  tags                 = local.tags
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"

  depends_on = [
    aws_eks_addon.vpc_cni
  ]

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # Block where using True/False values, we are configuring which add-on should be installed
  enable_karpenter                       = false
  enable_aws_node_termination_handler    = false
  enable_aws_load_balancer_controller    = true
  enable_cluster_autoscaler              = false
  enable_metrics_server                  = false
  enable_kubecost                        = false
  enable_amazon_eks_adot                 = false
  enable_aws_efs_csi_driver              = false
  enable_aws_for_fluentbit               = false
  enable_self_managed_aws_ebs_csi_driver = false
  enable_crossplane                      = false
  enable_argocd                          = false

# In this case for the aws_load_balancer_controller add-on, we can also configure parameters for its installation using Helm
aws_load_balancer_controller_helm_config = {
    version   = var.aws-lbc-helm-chart-version
    namespace = "aws-load-balancer-controller"

    set = concat([{
      name  = "replicaCount"
      value = 1
      },
      {
        name  = "vpcId"
        value = module.vpc.vpc_id
      }]
    )
  }

tags = local.tags
}