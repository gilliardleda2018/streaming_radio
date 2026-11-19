#!/usr/bin/env bash
set -Eeuo pipefail
# Execucao manual apenas, nunca por CI.
# Exige projeto dedicado ja existente, billing habilitado, API Compute habilitada,
# budget/alertas revisados e permissao explicita para criar recursos cobraveis.
command -v gcloud >/dev/null || { echo "gcloud nao encontrado" >&2; exit 1; }
PROJECT="${GCP_PROJECT_ID:-}"
[[ -n "$PROJECT" ]] || { echo "Defina GCP_PROJECT_ID para um projeto DEDICADO." >&2; exit 1; }
ZONE="${GCP_ZONE:-southamerica-east1-a}"
NAME="aggilli-radio-test"
echo "Projeto: $PROJECT | Zona: $ZONE | VM: $NAME"
echo "CUSTOS: VM e2-medium, disco 50GB pd-balanced, IP externo efemero e trafego."
echo "Este script nao configura DNS, backups, firewall publico ou AzuraCast."
gcloud compute instances describe "$NAME" --project="$PROJECT" --zone="$ZONE" >/dev/null 2>&1 && { echo "VM ja existe; abortando."; exit 1; }
echo "Inspecione o projeto, billing, rede e custos antes de prosseguir."
read -r -p "Digite CRIAR-VM para provisionar recurso cobrado: " CONFIRM
[[ "$CONFIRM" == "CRIAR-VM" ]] || { echo "Cancelado."; exit 0; }
gcloud compute instances create "$NAME" \
  --project="$PROJECT" \
  --zone="$ZONE" \
  --machine-type=e2-medium \
  --image-family=ubuntu-2404-lts-amd64 \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=50GB \
  --boot-disk-type=pd-balanced \
  --tags=aggilli-radio-test \
  --labels=app=aggilli-radio,environment=test \
  --metadata=enable-oslogin=TRUE \
  --no-address
echo "VM criada SEM IP publico; use IAP/OS Login e configure acesso externo somente apos revisao."
