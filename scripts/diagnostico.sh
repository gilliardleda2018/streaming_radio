#!/usr/bin/env bash
set -u
echo "=== AGGILLI RADIO | DIAGNOSTICO (SOMENTE LEITURA) ==="
echo "-- Sistema --"
cat /etc/os-release 2>/dev/null || true
uname -m
echo "-- CPU e RAM --"
lscpu 2>/dev/null | grep -E 'Model name|CPU\(s\)' || true
free -h || true
echo "-- Disco --"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS || true
df -h / /var 2>/dev/null || true
echo "-- Portas TCP locais --"
ss -ltn || true
echo "-- Dependencias --"
for binary in git curl docker; do
 if command -v "$binary" >/dev/null 2>&1; then echo "$binary: presente"; else echo "$binary: ausente"; fi
done
if command -v docker >/dev/null 2>&1; then docker compose version 2>/dev/null || true; fi
echo "-- Diretorio AzuraCast --"
if [[ -e /var/azuracast ]]; then echo "EXISTE: inspecione antes de instalar"; else echo "nao encontrado"; fi
echo "=== FIM ==="
