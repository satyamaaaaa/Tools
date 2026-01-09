#!/bin/bash

echo "=============================================="
echo " Project 6: Attack Surface Mapper"
echo "=============================================="
echo

# Root check
if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root (sudo)"
    exit 1
fi

OUT="surface_map_$(date +%F_%H-%M).txt"
SUCCESS=1

echo "[+] Mapping open ports"
echo "=== OPEN PORTS ===" > "$OUT"
ss -tuln >> "$OUT" || SUCCESS=0

echo "[+] Listing running services"
echo "" >> "$OUT"
echo "=== RUNNING SERVICES ===" >> "$OUT"
systemctl list-units --type=service --state=running >> "$OUT" || SUCCESS=0

echo "[+] Searching for world-writable files (limited paths)"
echo "" >> "$OUT"
echo "=== WORLD-WRITABLE FILES ===" >> "$OUT"

# Limit scan to common risky directorie
