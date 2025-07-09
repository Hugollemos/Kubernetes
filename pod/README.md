# Pods no Kubernetes

Este diretório contém exemplos e documentação sobre Pods, a menor unidade deployável no Kubernetes.

## 📋 O que são Pods

Pods são:
- A menor unidade deployável no Kubernetes
- Podem conter um ou mais containers
- Containers em um Pod compartilham:
  - Endereço IP
  - Volumes
  - Namespace de rede
  - Ciclo de vida

## 📁 Arquivos neste Diretório

- `pod.yaml` - Exemplo de manifesto de Pod

## 📄 Estrutura Básica de um Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: exemplo-pod
  labels:
    app: exemplo
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

## 🔧 Comandos Úteis

```bash
# Aplicar manifesto
kubectl apply -f pod.yaml

# Listar pods
kubectl get pods

# Descrever pod
kubectl describe pod <nome-pod>

# Logs do pod
kubectl logs <nome-pod>

# Deletar pod
kubectl delete pod <nome-pod>
```

## 📚 Conceitos Importantes

- **Ephemeral**: Pods são temporários
- **Shared Network**: Containers compartilham IP
- **Shared Storage**: Volumes são compartilhados
- **Atomic**: Pod como unidade indivisível

Para mais informações, consulte a [documentação principal](../README.md).