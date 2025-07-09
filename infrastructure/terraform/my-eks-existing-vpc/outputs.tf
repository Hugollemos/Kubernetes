# Informações do Cluster
output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.master.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.master.cluster_endpoint
}

output "cluster_version" {
  description = "Versão do Kubernetes do cluster"
  value       = module.master.cluster_version
}

output "cluster_arn" {
  description = "ARN do cluster EKS"
  value       = module.master.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "Dados do certificado de autoridade do cluster"
  value       = module.master.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  description = "ID do security group do cluster"
  value       = module.master.security_group_id
}

# Informações dos Worker Nodes
output "node_group_arn" {
  description = "ARN do node group"
  value       = module.nodes.node_group_arn
}

output "node_group_status" {
  description = "Status do node group"
  value       = module.nodes.node_group_status
}

output "node_group_capacity_type" {
  description = "Tipo de capacidade do node group"
  value       = module.nodes.node_group_capacity_type
}

output "node_group_instance_types" {
  description = "Tipos de instância do node group"
  value       = module.nodes.node_group_instance_types
}

# Informações de Rede
output "vpc_id" {
  description = "ID da VPC utilizada"
  value       = data.aws_vpc.existing.id
}

output "vpc_cidr_block" {
  description = "CIDR block da VPC"
  value       = data.aws_vpc.existing.cidr_block
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas utilizadas"
  value       = var.private_subnet_ids
}

output "availability_zones" {
  description = "Zonas de disponibilidade das subnets"
  value       = [for subnet in data.aws_subnet.private : subnet.availability_zone]
}

# Comandos úteis
output "kubectl_config_command" {
  description = "Comando para configurar kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}

output "cluster_info" {
  description = "Informações resumidas do cluster"
  value = {
    name               = module.master.cluster_name
    endpoint           = module.master.cluster_endpoint
    version            = module.master.cluster_version
    region             = var.aws_region
    vpc_id             = data.aws_vpc.existing.id
    node_group_name    = var.node_group_name
    node_count_desired = var.auto_scale_options.desired
    node_count_min     = var.auto_scale_options.min
    node_count_max     = var.auto_scale_options.max
    instance_types     = var.nodes_instances_sizes
  }
}
