output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_blueprints.eks_cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks_blueprints.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

output "eks_cluster_name" {
  description = "Amazon EKS Cluster Name"
  value       = module.eks_blueprints.eks_cluster_id
}