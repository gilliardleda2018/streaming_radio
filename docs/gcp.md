# Google Cloud - plano de provisionamento isolado

Regiao: `southamerica-east1` (Sao Paulo). Zona inicial: `southamerica-east1-a`.
Ambiente: **teste**, uma radio, sem alteracoes em projetos existentes.

## Etapa 1: inventario (somente leitura)
Execute em Cloud Shell com a conta correta:
```bash
git clone https://github.com/gilliardleda2018/streaming_radio.git
cd streaming_radio
bash scripts/gcp-inventory.sh
```
Verifique conta, projetos, billing, VMs, enderecos e firewall. O script nao consegue consultar faturas detalhadas nem comprovar quotas. Use Console Billing > Reports/Budgets e IAM & Admin > Quotas.

## Etapa 2: projeto dedicado e controle de gastos
Criar manualmente projeto exclusivo (por exemplo `aggilli-radio-test`), associar billing, habilitar Compute Engine API, criar budget com alertas (50%, 80%, 100%). Budget nao e limite rigido: alertas nao desligam VM automaticamente. Conferir quotas e capacidade na zona. Evitar Spot para radio 24h.

## Etapa 3: provisionamento sob confirmacao
O script nao deve ser executado antes da aprovacao dos custos. A VM nasce **sem IP publico** e sem portas abertas.
```bash
export GCP_PROJECT_ID='SEU-PROJETO-DEDICADO'
bash scripts/gcp-provision-test.sh
```
A VM tem Ubuntu 24.04, e2-medium, disco pd-balanced de 50GB, tag exclusiva e OS Login.
Nao altera outras instancias ou firewalls. Configurar acesso administrativo por IAP e SSH com IAM.

## Etapa 4: radio
Confirmar compatibilidade AzuraCast/Ubuntu, instalar Docker e AzuraCast na VM, com `scripts/instalar-azuracast.sh` apos revisao. Para disponibilizar a radio publicamente, planejar IP externo estatico, DNS, HTTPS, regras de firewall exclusivas e teste de portas. Nao abrir interface administrativa sem autenticacao e TLS.

## Estimativa inicial
Computacao e2-medium na regiao ~US$39/mes (730h), mais disco 50GB, endereco IPv4 e trafego de saida. Custo real depende da tabela vigente, descontos, impostos e volume de ouvintes. Para 100 ouvintes 128kbps 24h/dia: ~4,15 TB/mes; trafego pode dominar a fatura.

## Limites de seguranca
Nao rodar gcloud config set project em projetos existentes automaticamente.
Nao criar recursos via GitHub Actions.
Nao armazenar credenciais, service account keys, IPs privados ou backups no repositorio.
Nao remover/modificar projetos, VMs, redes ou firewalls existentes.
