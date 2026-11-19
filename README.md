# Aggilli Radio Streaming

Servidor remoto para **uma radio**, com painel AzuraCast, Icecast e Liquidsoap (AutoDJ), hospedado em **AWS EC2** ou **Google Cloud Compute Engine**.

## Arquitetura do piloto

- Sistema operacional: Ubuntu Server 22.04 LTS (referenciado pela documentacao AzuraCast), ou Debian com Docker, apos validacao de compatibilidade.
- Instancia inicial sugerida: **2 vCPU, 4 GB RAM, SSD 40-60 GB**, ampliavel apos teste. Para configuracao confortavel: 4 vCPU e 4-8 GB.
- 1 VM com IP publico estatico, disco persistente, firewall restrito, Docker e instalacao oficial AzuraCast.
- Painel web e streaming HTTPS via dominio e TLS; SSH somente para IP administrativo conhecido, de preferencia acesso via SSM/IAP.
- Backups externos criptografados: S3 ou Cloud Storage; alertas de custo e trafego.
- Nao armazenar credenciais, arquivos .env, acervo musical ou backups no GitHub.

## Implantacao (na VM nova)

```bash
git clone https://github.com/gilliardleda2018/streaming_radio.git
cd streaming_radio
bash scripts/diagnostico.sh
```

Leia [docs/cloud.md](docs/cloud.md), revise as portas, permissoes e custos e **somente entao**, numa VM dedicada:

```bash
sudo bash scripts/instalar-azuracast.sh
```

Esse instalador exige confirmacao interativa e usa o instalador oficial do AzuraCast; nao provisiona AWS/GCP, DNS, HTTPS ou firewall automaticamente.

**Situacao:** infraestrutura ainda nao criada; esta entrega e somente a base versionada.

Referencias: [Requisitos](https://www.azuracast.com/docs/getting-started/requirements/) | [Docker](https://www.azuracast.com/docs/getting-started/installation/docker/).
