# Cluster Information
output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = var.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.master.eks_cluster.endpoint
}

output "cluster_version" {
  description = "Versão do Kubernetes"
  value       = module.master.eks_cluster.version
}

output "cluster_arn" {
  description = "ARN do cluster EKS"
  value       = module.master.eks_cluster.arn
}

output "cluster_security_group_id" {
  description = "ID do Security Group do cluster"
  value       = module.master.security_group.id
}

# Network Information
output "vpc_id" {
  description = "ID da VPC"
  value       = module.network.cluster_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block da VPC"
  value       = module.network.cluster_vpc.cidr_block
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value = [
    module.network.private_subnet_1a.id,
    module.network.private_subnet_1c.id
  ]
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value = [
    module.network.public_subnet_1a.id,
    module.network.public_subnet_1c.id
  ]
}

# kubectl Configuration Command
output "kubectl_config_command" {
  description = "Comando para configurar kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}

# Useful Information
output "region" {
  description = "Região AWS utilizada"
  value       = var.aws_region
}

output "availability_zones" {
  description = "Zonas de disponibilidade utilizadas"
  value = [
    "${var.aws_region}a",
    "${var.aws_region}c"
  ]
}