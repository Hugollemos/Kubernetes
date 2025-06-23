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

variable "cluster_vpc" {
  description = "ID da VPC onde o cluster será criado"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs das subnets privadas"
  type        = list(string)
}

variable "tags" {
  description = "Tags a serem aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
