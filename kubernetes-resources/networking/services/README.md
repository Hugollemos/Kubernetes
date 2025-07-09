# Services no Kubernetes

Os Services são abstrações que definem um conjunto lógico de pods e uma política de acesso a eles. Eles permitem que os pods se comuniquem entre si e com o mundo exterior de forma confiável.

## 📋 Índice

- [O que são Services](#o-que-são-services)
- [Tipos de Services](#tipos-de-services)
- [Exemplos Práticos](#exemplos-práticos)
- [Comandos Úteis](#comandos-úteis)
- [Troubleshooting](#troubleshooting)

## 🎯 O que são Services

Services resolvem os seguintes problemas:
- **IPs dinâmicos**: Pods podem ser criados e destruídos, mudando seus IPs
- **Descoberta de serviços**: Como os pods encontram outros pods
- **Load balancing**: Distribuição de carga entre múltiplas réplicas
- **Exposição externa**: Como acessar aplicações de fora do cluster

## 📊 Tipos de Services

### 1️⃣ ClusterIP (Padrão)

**Características:**
- Facilita a comunicação pod-a-pod dentro do cluster
- Não é acessível diretamente do mundo exterior
- Utiliza um endereço IP estático interno
- Quando solicitado, o tráfego é automaticamente roteado para um dos pods

**Uso típico:**
- Bancos de dados internos
- APIs internas
- Serviços de backend

**Exemplo:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  type: ClusterIP
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8080
```

### 2️⃣ NodePort

**Características:**
- Ao ser criado, o kube-proxy disponibiliza uma porta no intervalo de 30000-32767
- Funciona em conjunto com o ClusterIP, redirecionando o tráfego para o pod correspondente
- Acessível externamente através de `<IP-do-Nó>:<NodePort>`
- **Fluxo**: Cliente Externo ➡️ Nó ➡️ NodePort ➡️ ClusterIP ➡️ Pod

**Uso típico:**
- Desenvolvimento e testes
- Aplicações simples que precisam de acesso externo
- Ambientes onde LoadBalancer não está disponível

**Exemplo:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-nodeport
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080  # Opcional, se não especificado será atribuído automaticamente
```

### 3️⃣ LoadBalancer

**Características:**
- Útil principalmente em ambientes de nuvem (AWS, GCP, Azure)
- Cria um balanceador de carga externo que distribui o tráfego entre os nós do cluster
- Facilita o roteamento do tráfego de clientes externos
- Inclui funcionalidades de ClusterIP e NodePort

**Uso típico:**
- Aplicações web em produção
- APIs públicas
- Serviços que precisam de alta disponibilidade

**Exemplo:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 8080
```

### 4️⃣ ExternalName

**Características:**
- Mapeia um service para um nome DNS externo
- Não possui seletores ou endpoints
- Útil para integração com serviços externos

**Exemplo:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: database.example.com
```

## 🛠️ Exemplos Práticos

### Service ClusterIP Completo
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-api
  labels:
    app: backend
spec:
  type: ClusterIP
  selector:
    app: backend
    tier: api
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
  - name: https
    port: 443
    targetPort: 8443
    protocol: TCP
```

### Service NodePort com Múltiplas Portas
```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-nodeport
spec:
  type: NodePort
  selector:
    app: myapp
  ports:
  - name: web
    port: 80
    targetPort: 8080
    nodePort: 30080
  - name: api
    port: 8080
    targetPort: 8080
    nodePort: 30081
```

### Service LoadBalancer para Cloud
```yaml
apiVersion: v1
kind: Service
metadata:
  name: cloud-app
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  type: LoadBalancer
  selector:
    app: cloudapp
  ports:
  - port: 80
    targetPort: 8080
```

## 🔧 Comandos Úteis

### Gerenciamento de Services
```bash
# Listar todos os services
kubectl get services
kubectl get svc

# Visualizar detalhes de um service
kubectl describe service <nome-service>

# Criar service expondo um deployment
kubectl expose deployment <nome-deployment> --port=80 --target-port=8080

# Criar service NodePort
kubectl expose deployment <nome> --type=NodePort --port=80

# Criar service LoadBalancer
kubectl expose deployment <nome> --type=LoadBalancer --port=80
```

### Debugging de Services
```bash
# Visualizar endpoints de um service
kubectl get endpoints <nome-service>

# Verificar logs do kube-proxy
kubectl logs -n kube-system -l k8s-app=kube-proxy

# Testar conectividade interna
kubectl run debug --image=busybox -it --rm -- /bin/sh
# Dentro do pod de debug:
nslookup <nome-service>
wget -qO- http://<nome-service>
```

### Port Forwarding
```bash
# Redirecionar porta do service para máquina local
kubectl port-forward service/<nome-service> 8080:80

# Redirecionar com IP específico
kubectl port-forward --address 0.0.0.0 service/<nome-service> 8080:80
```

## 🔍 Troubleshooting

### Problemas Comuns

**1. Service não encontra pods**
```bash
# Verificar se os labels do service correspondem aos pods
kubectl get pods --show-labels
kubectl describe service <nome-service>

# Verificar endpoints
kubectl get endpoints <nome-service>
```

**2. Conexão é recusada**
```bash
# Verificar se o pod está ouvindo na porta correta
kubectl exec -it <nome-pod> -- netstat -tlnp

# Verificar se o targetPort está correto
kubectl describe service <nome-service>
```

**3. LoadBalancer não obtém IP externo**
```bash
# Verificar se o provedor de nuvem suporta LoadBalancer
kubectl describe service <nome-service>

# Verificar eventos
kubectl get events --field-selector involvedObject.name=<nome-service>
```

### Verificação de Conectividade
```bash
# Teste de conectividade interna
kubectl run test-pod --image=busybox --rm -it -- /bin/sh
# Dentro do pod:
ping <nome-service>
telnet <nome-service> 80

# Teste de DNS
nslookup <nome-service>
nslookup <nome-service>.<namespace>.svc.cluster.local
```

## 📝 Boas Práticas

1. **Use nomes descritivos** para services
2. **Defina labels consistentes** para facilitar seleção
3. **Use health checks** nos pods para garantir que apenas pods saudáveis recebam tráfego
4. **Monitore métricas** de latência e throughput
5. **Use annotations** para configurações específicas do provedor
6. **Implemente circuit breakers** para resiliência
7. **Considere usar Ingress** para exposição externa mais avançada

## 🚀 Integração com Ingress

Para exposição externa mais sofisticada, considere usar Ingress junto com Services:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
```

---

**Versão**: 2.0  
**Última atualização**: Julho 2025  
**Documentação completa**: [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)