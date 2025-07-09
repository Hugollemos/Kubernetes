variable "aws_region" {
  description = "Região AWS"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "k8s_version" {
  description = "Versão do Kubernetes"
  type        = string
}

variable "node_group_name" {
  description = "Nome do node group"
  type        = string
}

variable "cluster_vpc" {
  description = "ID da VPC onde o cluster foi criado"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs das subnets privadas"
  type        = list(string)
}

variable "eks_cluster" {
  description = "Objeto do cluster EKS"
  type        = any
}

variable "eks_cluster_sg" {
  description = "Security group do cluster EKS"
  type        = any
}

variable "nodes_instances_sizes" {
  description = "Tipos de instância para os worker nodes"
  type        = list(string)
}

variable "auto_scale_options" {
  description = "Configurações de auto scaling"
  type = object({
    min     = number
    max     = number
    desired = number
  })
}

variable "tags" {
  description = "Tags a serem aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
