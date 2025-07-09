output "node_group" {
  description = "Objeto do node group EKS"
  value       = aws_eks_node_group.cluster
}

output "node_group_arn" {
  description = "ARN do node group"
  value       = aws_eks_node_group.cluster.arn
}

output "node_group_status" {
  description = "Status do node group"
  value       = aws_eks_node_group.cluster.status
}

output "node_group_capacity_type" {
  description = "Tipo de capacidade do node group"
  value       = aws_eks_node_group.cluster.capacity_type
}

output "node_group_instance_types" {
  description = "Tipos de instância do node group"
  value       = aws_eks_node_group.cluster.instance_types
}

output "node_group_scaling_config" {
  description = "Configuração de scaling do node group"
  value       = aws_eks_node_group.cluster.scaling_config
}

output "node_group_remote_access" {
  description = "Configuração de acesso remoto do node group"
  value       = aws_eks_node_group.cluster.remote_access
}

output "nodes_iam_role_arn" {
  description = "ARN da IAM role dos nodes"
  value       = aws_iam_role.eks_nodes_roles.arn
}

output "nodes_iam_role_name" {
  description = "Nome da IAM role dos nodes"
  value       = aws_iam_role.eks_nodes_roles.name
}
