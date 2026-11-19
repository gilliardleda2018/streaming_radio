#!/usr/bin/env bash
set -u
if [[ ! -d /var/azuracast ]]; then echo "AzuraCast nao encontrado em /var/azuracast"; exit 0; fi
command -v docker >/dev/null || { echo "Docker ausente" >&2; exit 1; }
cd /var/azuracast
docker compose ps
