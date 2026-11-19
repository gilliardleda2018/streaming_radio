# Plano para nuvem (AWS ou Google Cloud)

## Objetivo
Servidor de teste remoto para uma unica radio, com possibilidade de migracao por backup/restauracao. Nao misturar com infraestrutura Aggilli existente.

## Dimensionamento
Comecar com 2 vCPU, 4GB RAM, disco SSD persistente de 40-60GB e medir uso. Documentacao AzuraCast recomenda 4 vCPU/4GB/40GB para varias estacoes: escalar conforme testes.

## Escolha da provedora

| Recurso | AWS | Google Cloud |
|---|---|---|
| VM | EC2 | Compute Engine |
| IP publico estatico | Elastic IP | External static IP |
| Disco | EBS gp3 | Persistent Disk |
| Backup | S3 | Cloud Storage |
| Controle de acesso | IAM + Session Manager | IAM + IAP/OS Login |
| Alertas | AWS Budgets/CloudWatch | Cloud Billing Budgets/Cloud Monitoring |

Nao supor que IP, disco, snapshot ou trafego sejam gratuitos. Tarifas dependem da regiao, classe e uso.

## Seguranca e rede
1. Criar instancia **nova e dedicada**, evitando afetar servicos existentes.
2. Liberar TCP 80/443 para web/stream HTTPS quando configurado; liberar porta do mount Icecast **somente se necessaria**, conforme porta definida no AzuraCast. Nunca abrir Docker API, banco de dados ou painel administrativo sem controles.
3. Preferir Session Manager (AWS) ou IAP/OS Login (GCP). Se SSH publico, restringir porta 22 ao IP administrativo.
4. IP estatico, DNS, certificado TLS e redirecionamento HTTPS; a origem nao deve expor senha por HTTP.
5. Ativar alertas de custo, CPU, disco, trafego de saida; habilitar backups e testar restauracao.
6. Verificar licencas/direitos autorais aplicaveis ao acervo.

## Custos de streaming
Trafego mensal aproximado em **GB decimais**, com ouvintes constantes:
`ouvintes * bitrate_kbps * 1000/8 * horas_por_dia * 30 * 3600 / 1e9`.

Exemplo: 100 ouvintes, 128 kbps, 24 horas por dia = **4.147,2 GB (~4,15 TB) por 30 dias**. O trafego pode custar mais que a VM. Escolher regiao e fornecedor com simulacao de custo real.

## Instalar na VM
```bash
sudo apt-get update
sudo apt-get install -y git curl ca-certificates
git clone https://github.com/gilliardleda2018/streaming_radio.git
cd streaming_radio
bash scripts/diagnostico.sh
sudo bash scripts/instalar-azuracast.sh
```
Observe: a instalacao AzuraCast via Docker pode solicitar instalacao de Docker e ajustes de portas. A interface de primeiro acesso so deve ser acessada conforme rede/TLS configurados.

## Validacao
- Admin: HTTPS seguro, configuracao de uma estacao, usuarios com acesso restrito.
- AutoDJ: playlist, metadados, vinhetas e programacao.
- Streaming: URL publica, teste em celular, teste com ouvintes concorrentes.
- Operacao: reinicio da VM, persistencia de dados, backup/restauracao e alertas.
- Registrar versoes de imagens e processo de atualizacao.

## Migração
Clonar o mesmo repositorio na VM definitiva. Restaurar banco, configuracoes e musica separadamente, a partir de backup seguro, sem publicacao no GitHub.
