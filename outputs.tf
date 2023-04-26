# Note that the "root module" output values are defined based on the 
# "cluster-project" child module

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.cluster-project.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.cluster-project.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = module.cluster-project.region
}

output "cluster_name" {
  description = "Amazon EKS Cluster Name"
  value       = module.cluster-project.eks_cluster_name
}