# Infrastructure as Code (IaC)

Este diretório contém toda a infraestrutura como código para provisionar clusters Kubernetes usando Terraform.

## 📁 Estrutura

```
infrastructure/
└── terraform/
    ├── my-eks/                    # Cluster EKS completo (com VPC nova)
    │   ├── README.md
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── provider.tf
    │   ├── modules/
    │   │   ├── master/           # Módulo do Control Plane
    │   │   ├── network/          # Módulo de rede (VPC, subnets, etc)
    │   │   └── nodes/            # Módulo dos Worker Nodes
    │   └── kubernetes/           # Manifestos para deploy após criação
    │       └── apps/
    └── my-eks-existing-vpc/       # Cluster EKS com VPC existente
        ├── README.md
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── provider.tf
        ├── terraform.tfvars.example
        ├── modules/
        │   ├── master/           # Módulo do Control Plane
        │   └── nodes/            # Módulo dos Worker Nodes
        └── kubernetes/           # Manifestos para deploy após criação
            └── apps/
```

## 🚀 Projetos Disponíveis

### 1. [my-eks](./terraform/my-eks/)
**Cluster EKS Completo**
- Cria nova VPC com todas as configurações de rede
- Ideal para novos projetos
- Inclui configuração completa de networking

### 2. [my-eks-existing-vpc](./terraform/my-eks-existing-vpc/)
**EKS com VPC Existente**
- Utiliza VPC já existente
- Ideal para integração com infraestrutura existente
- Configuração mais simples

## 📋 Pré-requisitos

1. **Terraform** instalado (versão >= 1.0)
2. **AWS CLI** configurado
3. **kubectl** instalado
4. **Credenciais AWS** configuradas

## 🔧 Como Usar

1. **Escolha o projeto** adequado às suas necessidades
2. **Navegue até o diretório** do projeto
3. **Configure as variáveis** necessárias
4. **Execute o Terraform**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 🔍 Estrutura dos Módulos

### Módulo Master (Control Plane)
- **iam.tf**: Configurações IAM para o control plane
- **master.tf**: Configuração do cluster EKS
- **security.tf**: Security groups
- **variables.tf**: Variáveis do módulo
- **outputs.tf**: Outputs do módulo

### Módulo Network (apenas my-eks)
- **vpc.tf**: Configuração da VPC
- **public.tf**: Subnets públicas
- **private.tf**: Subnets privadas
- **internet.tf**: Internet Gateway
- **nat-gateway.tf**: NAT Gateway
- **variables.tf**: Variáveis do módulo
- **outputs.tf**: Outputs do módulo

### Módulo Nodes (Worker Nodes)
- **iam.tf**: Configurações IAM para os nodes
- **node_group.tf**: Configuração do node group
- **variables.tf**: Variáveis do módulo
- **outputs.tf**: Outputs do módulo

## 📝 Melhores Práticas

1. **Sempre execute `terraform plan`** antes de aplicar
2. **Use workspaces** para diferentes ambientes
3. **Mantenha arquivos de estado** seguros
4. **Revise outputs** após aplicar
5. **Use tags** consistentes nos recursos

## 🛠️ Customização

Para customizar a infraestrutura:

1. **Edite as variáveis** em `variables.tf`
2. **Ajuste os módulos** conforme necessário
3. **Modifique tags** e configurações específicas
4. **Teste em ambiente de desenvolvimento** primeiro

## 📊 Monitoramento

Após criar a infraestrutura:

1. **Configure kubectl** para acessar o cluster
2. **Deploy aplicações** usando os manifestos em `kubernetes/apps/`
3. **Configure monitoramento** e logging
4. **Implemente backup** e disaster recovery

---

**Versão**: 1.0  
**Última atualização**: Janeiro 2025