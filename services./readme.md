1️⃣ ClusterIP
- Facilita a comunicação pod-a-pod dentro do cluster.
- Não é acessível diretamente do mundo exterior.
- Utiliza um endereço IP estático.
- Quando solicitado, o tráfego é automaticamente roteado para um dos pods por trás do serviço.

2️⃣ NodePort
- Ao ser criado, o kube-proxy disponibiliza uma porta no intervalo de 30000-32767 para acesso externo.
- Funciona em conjunto com o ClusterIP, redirecionando o tráfego para o pod correspondente.
- Não realiza balanceamento de carga.
- Fluxo: Cliente Externo ➡️ Nó ➡️ NodePort ➡️ ClusterIP ➡️ Pod.

3️⃣ LoadBalancer
- O serviço LoadBalancer é útil principalmente em ambientes de nuvem.
- cria um balanceador de carga externo que distribui o tráfego entre os nós do cluster.
- Facilita o roteamento do tráfego de Cliente