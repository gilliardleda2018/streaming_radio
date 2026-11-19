#!/usr/bin/env bash
set -Eeuo pipefail
if [[ "$EUID" -ne 0 ]]; then echo "Execute como root (sudo)." >&2; exit 1; fi
if [[ -e /var/azuracast ]]; then echo "/var/azuracast ja existe. Abortando para nao sobrescrever." >&2; exit 1; fi
command -v curl >/dev/null || { echo "Instale curl antes de continuar." >&2; exit 1; }
echo "AVISO: o instalador AzuraCast pode instalar Docker, criar volumes e publicar portas."
echo "Use somente em VM dedicada, com firewall cloud, backup e custos revisados."
read -r -p "Digite INSTALAR para permitir download e execucao do instalador oficial: " answer
[[ "$answer" == INSTALAR ]] || { echo "Cancelado."; exit 0; }
mkdir -p /var/azuracast
cd /var/azuracast
curl -fsSL --retry 3 https://raw.githubusercontent.com/AzuraCast/AzuraCast/main/docker.sh -o docker.sh
chmod 755 docker.sh
echo "Instalador salvo em /var/azuracast/docker.sh; revise antes de continuar."
read -r -p "Digite EXECUTAR para iniciar ./docker.sh install: " answer
[[ "$answer" == EXECUTAR ]] || { echo "Download concluido; instalacao nao executada."; exit 0; }
./docker.sh install
