# Deployments no Kubernetes

Este diretório contém exemplos e documentação sobre Deployments, que gerenciam ReplicaSets e proporcionam atualizações declarativas para Pods.

## 📋 O que são Deployments

Deployments são:
- Controladores que gerenciam ReplicaSets
- Proporcionam atualizações declarativas para Pods
- Permitem rollbacks e rollouts
- Garantem número desejado de réplicas

## 📁 Arquivos neste Diretório

- `deployment.yaml` - Exemplo de manifesto de Deployment

## 📄 Estrutura Básica de um Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: exemplo-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: exemplo
  template:
    metadata:
      labels:
        app: exemplo
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

## 🔧 Comandos Úteis

```bash
# Aplicar deployment
kubectl apply -f deployment.yaml

# Listar deployments
kubectl get deployments

# Descrever deployment
kubectl describe deployment <nome-deployment>

# Escalar deployment
kubectl scale deployment <nome-deployment> --replicas=5

# Rollout
kubectl rollout status deployment <nome-deployment>
kubectl rollout history deployment <nome-deployment>
kubectl rollout undo deployment <nome-deployment>
```

## 📚 Conceitos Importantes

- **ReplicaSet**: Gerenciado automaticamente pelo Deployment
- **Rolling Update**: Atualização gradual sem downtime
- **Rollback**: Volta para versão anterior
- **Scaling**: Ajuste dinâmico de réplicas

## 🎯 Hierarquia

```
Deployment → ReplicaSet → Pod
```

Para mais informações, consulte a [documentação principal](../README.md).