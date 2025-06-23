# Configuração do Cluster
variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "eks-existing-vpc"
}

variable "aws_region" {
  description = "Região AWS onde o cluster será criado"
  type        = string
  default     = "us-east-1"
}

variable "k8s_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.28"
}

# Recursos de Rede Existentes (OBRIGATÓRIO)
variable "vpc_id" {
  description = "ID da VPC existente"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas existentes (mínimo 2 AZs)"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "Você deve fornecer pelo menos 2 subnets privadas em AZs diferentes."
  }
}

# Configuração dos Worker Nodes
variable "nodes_instances_sizes" {
  description = "Tipos de instância para os worker nodes"
  type        = list(string)
  default     = ["t3.large"]
}

variable "auto_scale_options" {
  description = "Configurações de auto scaling para os worker nodes"
  type = object({
    min     = number
    max     = number
    desired = number
  })
  default = {
    min     = 2
    max     = 10
    desired = 2
  }
}

# Configurações Opcionais
variable "node_group_name" {
  description = "Nome do node group"
  type        = string
  default     = "main-nodes"
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
