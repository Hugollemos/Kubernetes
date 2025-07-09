# StatefulSets e Volumes

Este diretório contém exemplos de StatefulSets e gerenciamento de volumes no Kubernetes, essenciais para aplicações stateful como bancos de dados.

## 📋 Conceitos

### StatefulSets
- Controlador para aplicações stateful
- Garante ordem de deployment e scaling
- Fornece identidades de rede estáveis
- Mantém persistent volumes entre restarts

### Volumes
- Armazenamento persistente para pods
- Diferentes tipos: EmptyDir, HostPath, PVC, etc.
- Sobrevivem ao ciclo de vida dos containers

## 📁 Arquivos neste Diretório

- `volumes.yml` - Exemplos de configuração de volumes

## 🗄️ Tipos de Volumes

### EmptyDir
Volume temporário que existe enquanto o Pod existir.
```yaml
volumes:
- name: cache-volume
  emptyDir: {}

volumeMounts:
- name: cache-volume
  mountPath: /cache
```

### HostPath
Monta um arquivo ou diretório do nó host.
```yaml
volumes:
- name: host-volume
  hostPath:
    path: /data
    type: Directory

volumeMounts:
- name: host-volume
  mountPath: /host-data
```

### PersistentVolumeClaim (PVC)
Requisição de armazenamento persistente.
```yaml
volumes:
- name: data-volume
  persistentVolumeClaim:
    claimName: data-pvc

volumeMounts:
- name: data-volume
  mountPath: /var/lib/data
```

## 📊 StatefulSets

### Estrutura Básica
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: database
spec:
  serviceName: database-headless
  replicas: 3
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      containers:
      - name: database
        image: postgres:13
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

### Headless Service
StatefulSets requerem um Headless Service para identidades de rede estáveis.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: database-headless
spec:
  clusterIP: None
  selector:
    app: database
  ports:
  - port: 5432
    targetPort: 5432
```

## 💾 Persistent Volumes (PV) e Claims (PVC)

### PersistentVolume
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-local
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /data/pv-local
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - worker-node-1
```

### PersistentVolumeClaim
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: local-storage
```

## 🏗️ StorageClass

### Definição de StorageClass
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  iops: "3000"
  throughput: "125"
allowVolumeExpansion: true
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

## 🔧 Comandos Úteis

### StatefulSets
```bash
# Criar StatefulSet
kubectl apply -f statefulset.yaml

# Listar StatefulSets
kubectl get statefulsets

# Descrever StatefulSet
kubectl describe statefulset database

# Escalar StatefulSet
kubectl scale statefulset database --replicas=5

# Deletar StatefulSet (mantém PVCs)
kubectl delete statefulset database

# Deletar StatefulSet e PVCs
kubectl delete statefulset database
kubectl delete pvc -l app=database
```

### Volumes e PVCs
```bash
# Listar PersistentVolumes
kubectl get pv

# Listar PersistentVolumeClaims
kubectl get pvc

# Descrever PVC
kubectl describe pvc database-pvc

# Verificar uso de storage
kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,CAPACITY:.status.capacity.storage

# Listar StorageClasses
kubectl get storageclass
```

## 📝 Padrões de Uso

### Banco de Dados MySQL
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql-headless
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: root-password
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
        livenessProbe:
          exec:
            command:
            - mysqladmin
            - ping
            - -h
            - localhost
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - mysql
            - -h
            - localhost
            - -e
            - "SELECT 1"
          initialDelaySeconds: 5
          periodSeconds: 5
  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 20Gi
```

### Redis Cluster
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis
spec:
  serviceName: redis-headless
  replicas: 6
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:6.2
        command:
        - redis-server
        - /etc/redis/redis.conf
        ports:
        - containerPort: 6379
        volumeMounts:
        - name: redis-data
          mountPath: /data
        - name: redis-config
          mountPath: /etc/redis
      volumes:
      - name: redis-config
        configMap:
          name: redis-config
  volumeClaimTemplates:
  - metadata:
      name: redis-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 5Gi
```

## 🎯 ConfigMaps para Configuração

### Configuração do Redis
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: redis-config
data:
  redis.conf: |
    appendonly yes
    appendfsync everysec
    save 900 1
    save 300 10
    save 60 10000
    tcp-keepalive 60
    maxmemory-policy allkeys-lru
```

## 📊 Backup e Restore

### Job para Backup
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: database-backup
spec:
  template:
    spec:
      containers:
      - name: backup
        image: postgres:13
        command:
        - pg_dump
        - -h
        - database-0.database-headless
        - -U
        - postgres
        - -d
        - myapp
        - -f
        - /backup/backup.sql
        volumeMounts:
        - name: backup-storage
          mountPath: /backup
        env:
        - name: PGPASSWORD
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: password
      volumes:
      - name: backup-storage
        persistentVolumeClaim:
          claimName: backup-pvc
      restartPolicy: Never
```

## 📝 Boas Práticas

1. **Use StatefulSets** para aplicações que precisam de:
   - Identidades de rede estáveis
   - Armazenamento persistente
   - Ordem de deployment/scaling

2. **Configure adequadamente**:
   - Probes de saúde
   - Resource limits
   - Backup strategies

3. **Monitore**:
   - Uso de storage
   - Performance de I/O
   - Saúde dos volumes

4. **Segurança**:
   - Use Secrets para credenciais
   - Configure RBAC adequadamente
   - Criptografia em repouso

5. **Disaster Recovery**:
   - Implemente backups regulares
   - Teste procedures de restore
   - Use replicação quando possível

## 🔍 Troubleshooting

### Problemas Comuns
```bash
# Pod em estado Pending por falta de PV
kubectl describe pod <pod-name>

# PVC em estado Pending
kubectl describe pvc <pvc-name>

# Verificar eventos relacionados a storage
kubectl get events --field-selector involvedObject.kind=PersistentVolumeClaim

# Verificar StorageClass
kubectl describe storageclass <storageclass-name>

# Verificar provisionamento dinâmico
kubectl logs -n kube-system deployment/ebs-csi-controller
```

Para mais informações, consulte a [documentação principal](../README.md).