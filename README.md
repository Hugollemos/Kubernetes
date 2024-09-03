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



minikube start
minikube status
minikube status
minikube start --nodes # -p <cluster_name>
kubectl get nodes
kubectl label node <node_name> node-role.kubernetes.io/worker=worker
kubectl get nodes
kubectl label nodes <node_name> role=worker
minikube stop
minikube delete



kubectl get nodes
kubectl label node <node_name> node-role.kubernetes.io/worker=worker
kubectl get nodes
kubectl label nodes <node_name> role=worker



Métricas-chave para Monitorar o Desempenho do Sistema Linux
CPU: Incluem médias de carga (uma medida da demanda de tarefa ao longo do tempo), utilização (quão ocupada a CPU está) e trocas de contexto (com que frequência a CPU muda de tarefas).

Memória: Acompanhe a memória livre, o uso de swap (um tipo de espaço de desbordamento para memória) e o estado dos buffers e cache (espaços de armazenamento temporário).

Disco: Isso abrange operações de I/O (transferências de dados), utilização de disco e latência (atrasos na transferência de dados).

Rede: Monitore o uso da largura de banda, pacotes descartados (dados descartados) e erros de transmissão.

Processo: Isso fornece insights sobre processos em execução e seu consumo de recursos de CPU e memória.


Ferramentas para Monitoramento
Integradas
top & htop: Monitor de sistema em tempo real.
vmstat: Fornece informações sobre processos, memória, paginação, etc.
iostat: Monitora o carregamento de dispositivos de entrada/saída do sistema.
netstat: Estatísticas de rede.
free: Exibe a quantidade de memória livre e usada.