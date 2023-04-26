variable "cluster_name" {
  description = "Cluster name used for Terraform provisioning"
  type        = string
  default     = "eks-cluster-project-07"
}

variable "vpc_cluster_name" {
  description = "VPC Cluster name used for Terraform provisioning"
  type        = string
  default     = "vpc-eks-cluster-project-07"
}

variable "terraform_tag" {
  description = "Default tag used for Terraform provisioning"
  type        = string
  default     = "eks-tfplan"
}

variable "ami_release_version" {
  description = "Default EKS AMI release version for node groups"
  type        = string
  default     = "1.24.11-20230411"
}

variable "node_instance_type" {
  description = "Default Instance Types for nodes"
  type        = list(string)
  default     = ["m5.large"]
}

variable "node_ami_type" {
  description = "Default AMI Type for nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.24"
}

variable "aws-lbc-helm-chart-version" {
  type        = string
  description = "aws load balancer controller helm chart version"
  default     = "1.5.2"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth ConfigMap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_accounts" {
  description = "Additional AWS accounts to add to the aws-auth ConfigMap"
  type = list(string)
  default = []
}

