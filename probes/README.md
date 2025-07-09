# Probes - Health Checks no Kubernetes

Este diretório contém exemplos de Health Checks (Probes) no Kubernetes, essenciais para garantir a confiabilidade das aplicações.

## 📋 O que são Probes

Probes são verificações de saúde que o Kubernetes executa nos containers para:
- Determinar quando um container está pronto para receber tráfego
- Detectar quando um container precisa ser reiniciado
- Garantir que o startup da aplicação seja bem-sucedido

## 📁 Arquivos neste Diretório

- `liveness.yml` - Exemplo de Liveness Probe
- `readiness.yml` - Exemplo de Readiness Probe  
- `startupProbe.yml` - Exemplo de Startup Probe

## 🔍 Tipos de Probes

### 1️⃣ Liveness Probe
Determina se o container está rodando. Se falhar, o kubelet mata o container.

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

### 2️⃣ Readiness Probe
Determina se o container está pronto para receber tráfego. Se falhar, remove o Pod dos endpoints do Service.

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### 3️⃣ Startup Probe
Determina se a aplicação dentro do container terminou de inicializar. Protege containers com startup lento.

```yaml
startupProbe:
  httpGet:
    path: /startup
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

## 🛠️ Tipos de Verificação

### HTTP GET
```yaml
httpGet:
  path: /health
  port: 8080
  httpHeaders:
  - name: Custom-Header
    value: Awesome
```

### TCP Socket
```yaml
tcpSocket:
  port: 8080
```

### Exec Command
```yaml
exec:
  command:
  - cat
  - /tmp/healthy
```

## ⚙️ Configurações Importantes

### Parâmetros Comuns
- `initialDelaySeconds`: Tempo antes da primeira verificação
- `periodSeconds`: Frequência das verificações
- `timeoutSeconds`: Timeout para cada verificação
- `successThreshold`: Sucessos consecutivos necessários
- `failureThreshold`: Falhas consecutivas para considerar falha

### Exemplo Completo
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-probes
spec:
  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 30
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
      timeoutSeconds: 3
      successThreshold: 1
      failureThreshold: 3
    startupProbe:
      httpGet:
        path: /
        port: 80
      failureThreshold: 30
      periodSeconds: 10
```

## 🔧 Comandos Úteis

```bash
# Aplicar manifesto com probes
kubectl apply -f liveness.yml

# Verificar eventos de probe failures
kubectl describe pod <nome-pod>

# Verificar logs do container
kubectl logs <nome-pod>

# Verificar status dos probes
kubectl get pod <nome-pod> -o yaml | grep -A 10 "conditions:"
```

## 📚 Boas Práticas

1. **Sempre use Readiness Probe** em aplicações web
2. **Liveness Probe deve ser leve** e rápido
3. **Startup Probe** para aplicações com inicialização lenta
4. **Endpoints dedicados** para health checks
5. **Não use dependências externas** em liveness probes
6. **Configure timeouts adequados** para sua aplicação
7. **Monitore métricas** de probe failures

## 🎯 Cenários de Uso

### Aplicação Web
```yaml
readinessProbe:
  httpGet:
    path: /api/health
    port: 8080
livenessProbe:
  httpGet:
    path: /api/alive
    port: 8080
```

### Base de Dados
```yaml
livenessProbe:
  exec:
    command:
    - pg_isready
    - -U
    - postgres
readinessProbe:
  exec:
    command:
    - pg_isready
    - -U
    - postgres
```

### Aplicação com Startup Lento
```yaml
startupProbe:
  httpGet:
    path: /startup
    port: 8080
  failureThreshold: 60
  periodSeconds: 10
```

Para mais informações, consulte a [documentação principal](../README.md).