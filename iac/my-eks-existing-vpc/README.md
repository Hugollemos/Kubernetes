# EKS Cluster com VPC Existente

## 📋 Visão Geral

Este projeto provisiona um **cluster Amazon EKS** usando uma **VPC e subnets existentes**. É uma versão otimizada que não cria recursos de rede, apenas o cluster EKS e os worker nodes.

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       VPC EXISTENTE (10.0.0.0/16)                          │
├─────────────────────────────────────────────────────────────────────────────┤
│  AZ us-east-1a                    │  AZ us-east-1c                          │
├──────────────────────────────      ├──────────────────────────────────────   │
│ Subnet Privada EXISTENTE            │ Subnet Privada EXISTENTE                │
│ ┌─────────────────────────┐         │ ┌──────────────────────────┐           │
│ │ ⚙️  EKS Control Plane   │         │ │ ⚙️  EKS Control Plane    │           │
│ │ 🖥️  Worker Nodes (2-10) │         │ │ 🖥️  Worker Nodes (2-10)  │           │
│ │     t3.large instances  │         │ │     t3.large instances   │           │
│ └─────────────────────────┘         │ └──────────────────────────┘           │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 🔧 Componentes Provisionados

### ✅ **O que SERÁ criado:**
- ⚙️ **EKS Control Plane** (Kubernetes 1.28)
- 🖥️ **EKS Node Group** (t3.large, Auto Scaling 2-10)
- 🔒 **IAM Roles** (Cluster + Worker Nodes)
- 🛡️ **Security Groups** (Control Plane)

### ❌ **O que NÃO será criado:**
- 🌐 VPC (usa existente)
- 🔌 Subnets (usa existentes)
- 🚪 Internet Gateway (usa existente)
- 📡 NAT Gateway (usa existente)
- 🛣️ Route Tables (usa existentes)

## 📁 Estrutura do Projeto

```
├── main.tf                 # Configuração principal com data sources
├── provider.tf             # AWS Provider
├── variables.tf            # Variáveis (incluindo IDs de recursos existentes)
├── outputs.tf              # Outputs importantes do cluster
├── terraform.tfvars        # Valores das variáveis (personalizar)
└── modules/
    ├── master/             # Módulo EKS Control Plane
    │   ├── master.tf       # Cluster EKS
    │   ├── iam.tf          # IAM Roles para cluster
    │   ├── security.tf     # Security Groups
    │   ├── variables.tf    # Variáveis do módulo
    │   └── outputs.tf      # Outputs do cluster
    └── nodes/              # Módulo Worker Nodes
        ├── node_group.tf   # EKS Node Groups
        ├── iam.tf          # IAM Roles para nodes
        ├── variables.tf    # Variáveis do módulo
        └── outputs.tf      # Outputs dos nodes
```

## ⚙️ Configuração

### 1. **Personalizar terraform.tfvars**

```hcl
# Nome do cluster
cluster_name = "meu-eks-cluster"

# Região AWS
aws_region = "us-east-1"

# IDs dos recursos existentes (OBRIGATÓRIO - substituir pelos seus)
vpc_id = "vpc-xxxxxxxxx"
private_subnet_ids = [
  "subnet-xxxxxxxxx",  # us-east-1a
  "subnet-yyyyyyyyy"   # us-east-1c
]

# Configuração do cluster
k8s_version = "1.28"
nodes_instances_sizes = ["t3.large"]
auto_scale_options = {
  min     = 2
  max     = 10
  desired = 2
}
```

### 2. **Obter IDs dos Recursos Existentes**

```bash
# Listar VPCs
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock]' --output table

# Listar subnets privadas
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=vpc-xxxxxxxxx" "Name=tag:Name,Values=*private*" \
  --query 'Subnets[*].[SubnetId,AvailabilityZone,CidrBlock,Tags[?Key==`Name`].Value|[0]]' \
  --output table
```

## 🚀 Deploy

### Pré-requisitos
- Terraform >= 1.3
- AWS CLI configurado
- VPC e subnets privadas já existentes
- Credenciais AWS com permissões para EKS

### Deploy do Cluster

```bash
# 1. Entrar na pasta do projeto
cd /home/hugo/ambiente/Kubernetes/iac/my-eks-existing-vpc

# 2. Personalizar terraform.tfvars com seus recursos existentes
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars com os IDs corretos

# 3. Inicializar Terraform
terraform init

# 4. Validar configuração
terraform validate

# 5. Planejar deployment
terraform plan

# 6. Aplicar infraestrutura
terraform apply
```

### Conectar ao Cluster

```bash
# Configurar kubectl
aws eks update-kubeconfig --region us-east-1 --name meu-eks-cluster

# Verificar nodes
kubectl get nodes

# Verificar status
kubectl cluster-info
```

## 📊 Vantagens desta Abordagem

### ✅ **Benefícios:**
- 🚀 **Deploy mais rápido** (não cria rede)
- 💰 **Evita custos duplicados** (reutiliza NAT Gateway)
- 🔄 **Reutiliza infraestrutura** existente
- 🛡️ **Mantém configurações de rede** já testadas
- 📦 **Modular** (pode ser destruído sem afetar a rede)

### ⚠️ **Considerações:**
- 🔍 **Requer IDs corretos** (VPC e subnets)
- 🏷️ **Tags podem ser necessárias** para subnets
- 🔐 **Permissões de rede** devem estar corretas

## 🔒 Tags Necessárias nas Subnets

Para o EKS funcionar corretamente, as subnets devem ter estas tags:

```bash
# Subnets privadas (onde ficam os worker nodes)
kubernetes.io/role/internal-elb = 1
kubernetes.io/cluster/[CLUSTER_NAME] = owned

# Subnets públicas (se existirem - para load balancers)
kubernetes.io/role/elb = 1
kubernetes.io/cluster/[CLUSTER_NAME] = owned
```

### Aplicar Tags nas Subnets:

```bash
# Substituir pelos seus valores
CLUSTER_NAME="meu-eks-cluster"
PRIVATE_SUBNET_1="subnet-xxxxxxxxx"
PRIVATE_SUBNET_2="subnet-yyyyyyyyy"

# Tags para subnets privadas
aws ec2 create-tags --resources $PRIVATE_SUBNET_1 $PRIVATE_SUBNET_2 --tags \
  Key=kubernetes.io/role/internal-elb,Value=1 \
  Key=kubernetes.io/cluster/$CLUSTER_NAME,Value=owned
```

## 🧹 Limpeza

```bash
# Destruir apenas o cluster (mantém a rede)
terraform destroy

# A VPC e subnets permanecerão intactas
```

## 🎯 Status do Projeto

### ✅ **Funcionalidades:**
- ✅ Cluster EKS 1.28
- ✅ Worker Nodes com Auto Scaling
- ✅ Usa VPC existente
- ✅ IAM configurado
- ✅ Security Groups otimizados
- ✅ Outputs informativos

### 🔄 **Próximos Passos:**
1. Deploy do cluster
2. Instalar Ingress Controller
3. Deploy das aplicações
4. Configurar monitoramento

---
**Versão:** 1.0  
**Terraform:** >= 1.3  
**Kubernetes:** 1.28  
**AWS Provider:** ~> 5.0  
