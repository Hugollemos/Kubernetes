# Kubernetes

Repositorio destinado para documentar meus estudos em kubernetes.

- Control Plane: Orquestra o cluster Kubernetes. Ele inclui vários componentes, como o Kube API Server, Kube Scheduler, Kube Controller Manager e etcd
- Worker Node: Executa as aplicações.
- Kube API Server: Responsável pela comunicação externa do Kubernetes.
- etcd: Banco de chave e valor.
- Kube Scheduler: Recebe todas as especificações do que será criado no cluster, como contêineres, objetos, etc.
- Kube Controller Manager: Gerencia os controladores do Kubernetes.
- Cloud Controller Manager (opcional): Controla os recursos de nuvem quando se está trabalhando com a nuvem.
- Kube Proxy: Kube Proxy é um componente que roda em cada nó de trabalho e é responsável por gerenciar a comunicação de rede, como redirecionamento de tráfego para os pods.
- Kubelet: Responsável pela verificação da execução dos contêineres.
