output "eks_cluster" {
  description = "Objeto do cluster EKS"
  value       = aws_eks_cluster.eks_cluster
}

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_version" {
  description = "Versão do Kubernetes do cluster"
  value       = aws_eks_cluster.eks_cluster.version
}

output "cluster_arn" {
  description = "ARN do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Dados do certificado de autoridade do cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_status" {
  description = "Status do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.status
}

output "security_group" {
  description = "Objeto do security group do cluster"
  value       = aws_security_group.cluster_master_sg
}

output "security_group_id" {
  description = "ID do security group do cluster"
  value       = aws_security_group.cluster_master_sg.id
}

output "cluster_iam_role_arn" {
  description = "ARN da IAM role do cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "cluster_iam_role_name" {
  description = "Nome da IAM role do cluster"
  value       = aws_iam_role.eks_cluster_role.name
}
