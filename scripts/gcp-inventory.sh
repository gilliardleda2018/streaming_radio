#!/usr/bin/env bash
set -Eeuo pipefail
# Somente leitura: nao cria, altera ou remove recursos.
command -v gcloud >/dev/null || { echo "Instale Google Cloud CLI"; exit 1; }
echo "=== IDENTIDADE E PROJETO ==="
gcloud auth list --filter='status:ACTIVE' --format='table(account,status)'
gcloud config list --format='text(core.project,compute.region,compute.zone)'
echo "=== PROJETOS ACESSIVEIS ==="
gcloud projects list --format='table(projectId,name,lifecycleState)'
echo "=== BILLING DO PROJETO ATIVO ==="
PROJECT="$(gcloud config get-value project 2>/dev/null)"
if [[ -n "$PROJECT" && "$PROJECT" != "(unset)" ]]; then
  gcloud billing projects describe "$PROJECT" --format='yaml' || true
  echo "=== VMS DO PROJETO ATIVO ==="
  gcloud compute instances list --project="$PROJECT" --format='table(name,zone,machineType,status,networkInterfaces[0].networkIP)' || true
  echo "=== ENDERECOS RESERVADOS ==="
  gcloud compute addresses list --project="$PROJECT" --format='table(name,region,address,status)' || true
  echo "=== REGRAS FIREWALL ==="
  gcloud compute firewall-rules list --project="$PROJECT" --format='table(name,network,direction,allowed)' || true
fi
echo "=== FIM (NENHUMA ALTERACAO REALIZADA) ==="
