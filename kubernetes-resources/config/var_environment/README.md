# Variáveis de Ambiente e ConfigMaps

Este diretório contém exemplos de como gerenciar configurações de aplicações no Kubernetes usando variáveis de ambiente, ConfigMaps e Secrets.

## 📋 Conceitos

### Variáveis de Ambiente
Maneira de passar configurações para containers através de variáveis do sistema.

### ConfigMaps
Objetos do Kubernetes para armazenar dados de configuração não confidenciais em pares chave-valor.

### Secrets
Similar aos ConfigMaps, mas projetados para armazenar dados sensíveis (senhas, tokens, chaves).

## 📁 Arquivos neste Diretório

- `var_environment.yml` - Exemplo de variáveis de ambiente em Pods
- `configmap-env.yml` - Exemplo de ConfigMap
- `deployment.yml` - Deployment usando ConfigMap

## 🔧 Variáveis de Ambiente

### Definição Simples
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-env
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: ENVIRONMENT
      value: "production"
    - name: DATABASE_URL
      value: "postgres://db:5432/myapp"
    - name: API_KEY
      value: "secret-key"
```

### A partir de ConfigMap
```yaml
env:
- name: DATABASE_HOST
  valueFrom:
    configMapKeyRef:
      name: app-config
      key: database.host
```

### A partir de Secret
```yaml
env:
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: app-secret
      key: database.password
```

## 📄 ConfigMaps

### Criação via YAML
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database.host: "postgresql.default.svc.cluster.local"
  database.port: "5432"
  database.name: "myapp"
  redis.url: "redis://redis:6379"
  app.properties: |
    debug=true
    log.level=info
    feature.new_ui=enabled
```

### Criação via kubectl
```bash
# A partir de valores literais
kubectl create configmap app-config \
  --from-literal=database.host=postgresql \
  --from-literal=database.port=5432

# A partir de arquivo
kubectl create configmap app-config \
  --from-file=config.properties

# A partir de diretório
kubectl create configmap app-config \
  --from-file=./config/
```

## 🔐 Secrets

### Criação de Secret
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  database.password: cGFzc3dvcmQxMjM=  # base64 encoded
  api.key: bXktc2VjcmV0LWtleQ==        # base64 encoded
```

### Criação via kubectl
```bash
# A partir de valores literais
kubectl create secret generic app-secret \
  --from-literal=database.password=password123 \
  --from-literal=api.key=my-secret-key

# A partir de arquivo
kubectl create secret generic app-secret \
  --from-file=./secrets/
```

## 🛠️ Uso em Deployments

### Todas as variáveis de ConfigMap
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:latest
        envFrom:
        - configMapRef:
            name: app-config
        - secretRef:
            name: app-secret
```

### Variáveis específicas
```yaml
env:
- name: DATABASE_HOST
  valueFrom:
    configMapKeyRef:
      name: app-config
      key: database.host
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: app-secret
      key: database.password
```

## 📂 Montagem como Volumes

### ConfigMap como Volume
```yaml
volumes:
- name: config-volume
  configMap:
    name: app-config
    items:
    - key: app.properties
      path: application.properties

containers:
- name: app
  image: myapp:latest
  volumeMounts:
  - name: config-volume
    mountPath: /etc/config
```

### Secret como Volume
```yaml
volumes:
- name: secret-volume
  secret:
    secretName: app-secret
    items:
    - key: database.password
      path: db-password
      mode: 0400

containers:
- name: app
  image: myapp:latest
  volumeMounts:
  - name: secret-volume
    mountPath: /etc/secrets
    readOnly: true
```

## 🔧 Comandos Úteis

### ConfigMaps
```bash
# Listar ConfigMaps
kubectl get configmaps

# Descrever ConfigMap
kubectl describe configmap app-config

# Visualizar dados do ConfigMap
kubectl get configmap app-config -o yaml

# Editar ConfigMap
kubectl edit configmap app-config

# Deletar ConfigMap
kubectl delete configmap app-config
```

### Secrets
```bash
# Listar Secrets
kubectl get secrets

# Descrever Secret
kubectl describe secret app-secret

# Visualizar dados do Secret (base64)
kubectl get secret app-secret -o yaml

# Decodificar Secret
kubectl get secret app-secret -o jsonpath='{.data.database\.password}' | base64 -d
```

## 📝 Boas Práticas

1. **Separe configuração de código**
2. **Use ConfigMaps para dados não sensíveis**
3. **Use Secrets para dados sensíveis**
4. **Organize por ambiente** (dev, staging, prod)
5. **Use labels para organização**
6. **Monitore mudanças** em ConfigMaps/Secrets
7. **Implemente rolling updates** quando configuração muda
8. **Use ferramentas de validação** para configurações

## 🔄 Atualização de Configurações

### Trigger de Rolling Update
```bash
# Forçar rolling update após mudança em ConfigMap
kubectl rollout restart deployment app-deployment

# Verificar status do rollout
kubectl rollout status deployment app-deployment
```

### Webhook para Auto-reload
Considere usar tools como:
- **Reloader** - Reinicia deployments automaticamente
- **Configmap-reload** - Sidecar para reload automático

## 🎯 Exemplo Prático Completo

```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config
data:
  database.host: "postgres.default.svc.cluster.local"
  database.port: "5432"
  database.name: "webapp"
  redis.url: "redis://redis:6379"
  log.level: "info"

---
# Secret
apiVersion: v1
kind: Secret
metadata:
  name: webapp-secret
type: Opaque
data:
  database.password: d2VicGFzcw==  # webpass
  jwt.secret: c3VwZXJzZWNyZXQ=     # supersecret

---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: webapp:latest
        env:
        - name: DATABASE_HOST
          valueFrom:
            configMapKeyRef:
              name: webapp-config
              key: database.host
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: webapp-secret
              key: database.password
        envFrom:
        - configMapRef:
            name: webapp-config
```

Para mais informações, consulte a [documentação principal](../README.md).