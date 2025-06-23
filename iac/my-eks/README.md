# Documentação Técnica - Cluster EKS Completo

## 📋 Visão Geral

Este projeto provisiona um **cluster Amazon EKS (Elastic Kubernetes Service) COMPLETO** na AWS usando Terraform, implementando uma arquitetura de alta disponibilidade com Control Plane e Worker Nodes distribuídos em subnets privadas em múltiplas zonas de disponibilidade.

## 🏗️ Arquitetura

### Diagrama de Rede
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          VPC (10.0.0.0/16)                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  AZ us-east-1a                    │  AZ us-east-1c                          │
├──────────────────────────────      ├──────────────────────────────────────   │
│ Public Subnet (10.0.0.0/20)        │ Public Subnet (10.0.16.0/20)           │
│ ┌─────────────────────────┐         │ ┌──────────────────────────┐           │
│ │   🌐 NAT Gateway        │         │ │                          │           │
│ │   📡 Elastic IP         │         │ │                          │           │
│ └─────────────────────────┘         │ └──────────────────────────┘           │
├──────────────────────────────       ├──────────────────────────────────────  │
│ Private Subnet (10.0.32.0/20)       │ Private Subnet (10.0.48.0/20)          │
│ ┌─────────────────────────┐         │ ┌──────────────────────────┐           │
│ │ ⚙️  EKS Control Plane   │         │ │ ⚙️  EKS Control Plane    │           │
│ │ 🖥️  Worker Nodes (1-5)  │         │ │ 🖥️  Worker Nodes (1-5)   │           │
│ │     t3.large instances  │         │ │     t3.large instances   │           │
│ └─────────────────────────┘         │ └──────────────────────────┘           │
└─────────────────────────────────────────────────────────────────────────────┘
                                │
                        🌐 Internet Gateway
```

## 🔧 Componentes da Infraestrutura

### 1. **🌐 Rede (Network Module) - ✅ ATIVO**
- **VPC**: `10.0.0.0/16` (65,536 IPs disponíveis)
- **Subnets Públicas**:
  - `us-east-1a`: `10.0.0.0/20` (4,094 IPs utilizáveis)
  - `us-east-1c`: `10.0.16.0/20` (4,094 IPs utilizáveis)
- **Subnets Privadas**:
  - `us-east-1a`: `10.0.32.0/20` (4,094 IPs utilizáveis)
  - `us-east-1c`: `10.0.48.0/20` (4,094 IPs utilizáveis)

### 2. **🚪 Gateway e Conectividade - ✅ ATIVO**
- **Internet Gateway**: Para acesso à internet das subnets públicas
- **NAT Gateway**: Localizado na subnet pública 1a para saída de internet das subnets privadas
- **Elastic IP**: `domain = "vpc"` (AWS Provider v5.100.0)
- **Route Tables**: Separadas para tráfego público e privado

### 3. **⚙️ Cluster EKS (Master Module) - ✅ ATIVO**
- **Control Plane**: Executado nas subnets privadas (`us-east-1a` e `us-east-1c`)
- **Versão Kubernetes**: `1.15` ⚠️ (DESATUALIZADA)
- **Security Group**: Permite tráfego HTTPS (443) de qualquer origem
- **IAM Roles**: 
  - `AmazonEKSClusterPolicy`
  - `AmazonEKSServicePolicy`

### 4. **🖥️ Worker Nodes (Nodes Module) - ✅ ATIVO**
- **Instâncias**: `t3.large`
- **Auto Scaling**:
  - Mínimo: 2 nodes
  - Máximo: 10 nodes  
  - Desejado: 2 nodes
- **Localização**: Subnets privadas (ambas AZs)
- **IAM Policies**:
  - `AmazonEKS_CNI_Policy`
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEC2ContainerRegistryReadOnly`

## 📁 Estrutura do Projeto

```
├── modules.tf              # ✅ Todos os módulos definidos
├── provider.tf             # ✅ AWS Provider v5.100.0
├── variables.tf            # ✅ Todas as variáveis definidas
├── output.tf               # ⚠️  Outputs (vazio)
├── .terraform.lock.hcl     # ✅ Provider lockado
├── .gitignore              # ✅ Git configurado
└── modules/
    ├── network/            # ✅ Módulo de rede (ATIVO)
    │   ├── vpc.tf          # VPC principal
    │   ├── public.tf       # Subnets públicas + associações
    │   ├── private.tf      # Subnets privadas + associações
    │   ├── internet.tf     # Internet Gateway e rotas públicas
    │   ├── nat-gateway.tf  # NAT Gateway, EIP e rotas privadas
    │   ├── variables.tf    # Variáveis do módulo
    │   └── output.tf       # ✅ Outputs (VPC, subnets)
    ├── master/             # ✅ Módulo EKS Control Plane (ATIVO)
    │   ├── master.tf       # Cluster EKS
    │   ├── iam.tf          # Roles e políticas IAM para cluster
    │   ├── security.tf     # Security Groups
    │   ├── variables.tf    # Variáveis do módulo
    │   └── output.tf       # ✅ Outputs (cluster, security group)
    └── nodes/              # ✅ Módulo Worker Nodes (ATIVO)
        ├── node_group.tf   # Node groups EKS
        ├── iam.tf          # Roles IAM para nodes
        └── variables.tf    # Variáveis do módulo
```

## ⚙️ Configuração Atual

### Variáveis Principais

| Variável | Valor Configurado | Descrição | Status |
|----------|-------------------|-----------|--------|
| `cluster_name` | `k8s-demo` | Nome do cluster EKS | ✅ Ativo |
| `aws_region` | `us-east-1` | Região AWS | ✅ Ativo |
| `k8s_version` | `1.15` | Versão do Kubernetes | ⚠️ Desatualizada |
| `nodes_instances_sizes` | `["t3.large"]` | Tipos de instância para nodes | ✅ Ativo |
| `auto_scale_options` | `{min=2, max=10, desired=2}` | Configuração de auto scaling | ✅ Ativo |

### Backend e Provider
- **Backend S3**: 
  - Bucket: `terragrunt-state-hugo-532582682531`
  - Key: `infra.tfstate`
  - Região: `us-east-1` ✅
  - Encryption: Habilitada ✅
- **AWS Provider**: `5.100.0` (constraint `~> 5.0`) ✅
- **Terraform**: `>= 1.3` ✅

## 🚀 Como Usar

### Pré-requisitos
- Terraform >= 1.3 ✅
- AWS CLI configurado
- Credenciais AWS com permissões para EKS, EC2, VPC, IAM

### Deploy Completo (Control Plane + Worker Nodes)

```bash
# 1. Inicializar o Terraform
terraform init

# 2. Validar configuração
terraform validate

# 3. Planejar deployment
terraform plan

# 4. Aplicar infraestrutura COMPLETA
terraform apply
```

### Conectar ao Cluster após Deploy

```bash
# 1. Configurar kubectl
aws eks update-kubeconfig --region us-east-1 --name k8s-demo

# 2. Verificar nodes
kubectl get nodes

# 3. Verificar status do cluster
kubectl cluster-info
```

## 🔒 Segurança

### Características de Segurança Implementadas:
- ✅ Control Plane em subnets privadas
- ✅ Worker Nodes em subnets privadas
- ✅ NAT Gateway para saída segura de internet
- ✅ Security Groups configurados
- ✅ IAM Roles com least privilege
- ✅ State file criptografado no S3
- ✅ Tráfego HTTPS (443) permitido para API do Kubernetes
- ✅ Auto Scaling configurado com limites

### Definição de Subnets Públicas vs Privadas:

#### **Subnets Públicas** (`public.tf`):
```hcl
# Características que tornam a subnet pública:
map_public_ip_on_launch = true              # IPs públicos automáticos
aws_route_table_association → igw_route_table  # Associação com tabela do IGW

# Rota no Internet Gateway (internet.tf):
destination_cidr_block = "0.0.0.0/0"      # Todo tráfego
gateway_id = aws_internet_gateway.gw.id    # Via Internet Gateway
```

#### **Subnets Privadas** (`private.tf`):
```hcl
# Características que tornam a subnet privada:
# map_public_ip_on_launch = false (padrão)  # Sem IPs públicos automáticos
aws_route_table_association → nat          # Associação com tabela do NAT

# Rota no NAT Gateway (nat-gateway.tf):
destination_cidr_block = "0.0.0.0/0"      # Todo tráfego
nat_gateway_id = aws_nat_gateway.nat.id    # Via NAT Gateway
```

## 🔧 Status e Troubleshooting

### ✅ Problemas Resolvidos

1. **✅ "Missing region value"**
   - **RESOLVIDO**: Região adicionada no backend S3

2. **✅ "vpc = true not expected"**
   - **RESOLVIDO**: Substituído por `domain = "vpc"`

3. **✅ Worker Nodes não aparecem**
   - **RESOLVIDO**: Módulo `nodes` agora está ativo

### ⚠️ Melhorias Recomendadas

1. **🔴 Versão Kubernetes Crítica**
   ```
   Atual: 1.15 (End of Life - Sem suporte)
   Recomendado: 1.28+ (Suporte atual)
   ```

2. **🟡 Outputs Ausentes**
   - Arquivo `output.tf` principal está vazio
   - Não é possível ver informações importantes após deploy

## 📊 Recursos Provisionados (Estado Atual)

### ✅ Recursos Ativos
| Tipo | Quantidade | Localização | Provider Version |
|------|------------|-------------|-------------------|
| VPC | 1 | us-east-1 | 5.100.0 |
| Subnets Públicas | 2 | us-east-1a, us-east-1c | 5.100.0 |
| Subnets Privadas | 2 | us-east-1a, us-east-1c | 5.100.0 |
| Internet Gateway | 1 | VPC | 5.100.0 |
| NAT Gateway | 1 | us-east-1a | 5.100.0 |
| Elastic IP | 1 | us-east-1a | 5.100.0 |
| EKS Cluster | 1 | Subnets privadas | 5.100.0 |
| EKS Node Group | 1 | Subnets privadas | 5.100.0 |
| Worker Nodes | 2-10 | Auto Scaling | 5.100.0 |
| Route Tables | 2 | Pública e Privada | 5.100.0 |
| Security Groups | 1 | Master SG | 5.100.0 |
| IAM Roles | 2 | Cluster + Nodes | 5.100.0 |

### Capacidade Total
- **IPs Disponíveis**: 65.536 (VPC)
- **IPs por Subnet**: 4.094 utilizáveis
- **Worker Nodes**: 2 a 10 instâncias t3.large
- **Disponibilidade**: Multi-AZ (us-east-1a, us-east-1c)

## 🏷️ Tags Aplicadas

Todos os recursos são taggeados com:
- `Name`: Formato `{cluster_name}-{tipo-recurso}`
- `kubernetes.io/cluster/{cluster_name}`: "shared" (cluster) / "owned" (nodes)

## ⚡ Ações Recomendadas

### 🔴 Críticas (Executar Imediatamente)
```bash
# 1. Atualizar versão do Kubernetes
# Editar variables.tf:
variable "k8s_version" {
  default = "1.28"  # ou versão mais recente
}

# 2. Aplicar atualização
terraform plan
terraform apply
```

### 🟡 Melhorias (Próximos Passos)
```bash
# 3. Adicionar outputs importantes
# No output.tf principal:
output "cluster_endpoint" {
  value = module.master.eks_cluster.endpoint
}

output "cluster_name" {
  value = var.cluster_name
}
```

### 🟢 Opcionais (Futuro)
1. **Add-ons EKS**: CoreDNS, kube-proxy, VPC CNI
2. **Monitoring**: CloudWatch Container Insights
3. **Load Balancers**: ALB Ingress Controller
4. **Storage**: EBS CSI Driver
5. **Security**: Pod Security Standards

## 🎯 Status do Projeto

### ✅ **COMPLETO E FUNCIONAL**
- ✅ Rede configurada e segura
- ✅ Control Plane ativo
- ✅ Worker Nodes ativos
- ✅ Auto Scaling configurado
- ✅ Todas as dependências resolvidas
- ✅ Provider atualizado (v5.100.0)

### ⚠️ **NECESSITA ATENÇÃO**
- 🔴 Kubernetes 1.15 (CRÍTICO - Atualizar)
- 🟡 Outputs ausentes

O cluster está **FUNCIONAL** mas necessita atualização da versão do Kubernetes antes de uso em produção.

## 🤝 Contribuição

Para modificar esta infraestrutura:
1. Faça alterações nos arquivos .tf apropriados
2. Execute `terraform plan` para revisar mudanças
3. Execute `terraform apply` para aplicar
4. Teste a funcionalidade
5. Atualize esta documentação

---
**Última análise**: Junho 2025  
**Status**: ✅ **CLUSTER COMPLETO E FUNCIONAL**  
**Prioridade**: 🔴 Atualizar Kubernetes 1.15 → 1.28+  
**AWS Provider**: 5.100.0 ✅  
**Terraform**: >= 1.3 ✅


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb"

## 🌐 Acessando a Aplicação

### 1. Verificar Status do NLB

```bash
# Verificar o endpoint externo do NLB (pode levar alguns minutos para provisionar)
kubectl get svc -n ingress-nginx

# Aguardar até que EXTERNAL-IP não seja <pending>
# O endpoint será algo como: xxx-yyy.elb.us-region.amazonaws.com
```

### 2. Aplicar os Manifestos da Aplicação

```bash
# Aplicar primeiro a aplicação (contém deployment, service, configmap)
kubectl apply -f kubernetes/apps/faker.yml

# Aplicar depois o ingress (depende do service)
kubectl apply -f kubernetes/apps/ingress.yml
```

### 3. Verificar Status dos Recursos

```bash
# Verificar pods
kubectl get pods

# Verificar services
kubectl get svc

# Verificar ingress (aguardar ADDRESS ser preenchido)
kubectl get ingress
```

### 4. Acessar a Aplicação

Após todos os recursos estarem rodando:

```bash
# Obter o endpoint do NLB
INGRESS_ENDPOINT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Acesse: http://$INGRESS_ENDPOINT"
```

**URLs da Aplicação:**
- **Frontend**: `http://[NLB-ENDPOINT]/`
- **API**: `http://[NLB-ENDPOINT]/api/` (se configurado)
- **Admin**: `http://[NLB-ENDPOINT]/admin/` (se configurado)

### 5. Troubleshooting

```bash
# Se o NLB não aparecer, verificar logs do controller
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller

# Verificar eventos do ingress
kubectl describe ingress nginx-ingress-pathbased

# Testar conectividade interna
kubectl port-forward svc/frontend-service 8080:80
# Então acesse: http://localhost:8080
```

### 6. Limpeza (quando necessário)

```bash
# Remover aplicação
kubectl delete -f kubernetes/apps/

# Remover ingress controller
helm uninstall ingress-nginx -n ingress-nginx
kubectl delete namespace ingress-nginx
```