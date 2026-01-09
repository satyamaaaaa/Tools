#!/bin/bash

echo "=============================================="
echo " Project 3: Incident Response Toolkit"
echo "=============================================="
echo

# Root check (important for lsof, ss)
if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root (sudo)"
    exit 1
fi

OUT="incident_$(date +%F_%H-%M)"
SUCCESS=1   # assume success

mkdir "$OUT" || SUCCESS=0

echo "[+] Collecting running processes"
ps aux > "$OUT/processes.txt" || SUCCESS=0

echo "[+] Collecting network connections"
ss -tulpan > "$OUT/network.txt" || SUCCESS=0

echo "[+] Collecting logged-in users"
who > "$OUT/users.txt" || SUCCESS=0

echo "[+] Collecting open files"
lsof > "$OUT/lsof.txt" || SUCCESS=0

# Package evidence only if collection succeeded
if [[ "$SUCCESS" -eq 1 ]]; then
    tar -czf "$OUT.tar.gz" "$OUT" || SUCCESS=0
    rm -rf "$OUT"
fi

# Print completion ONLY if everything succeeded
if [[ "$SUCCESS" -eq 1 ]]; then
    echo
    echo "=============================================="
    echo " ✅ Project 3 Completed Successfully"
    echo " Incident evidence saved as:"
    echo " $OUT.tar.gz"
    echo "=============================================="
else
    echo
    echo "[!] Project 3 failed — evidence collection incomplete"
    exit 1
fi
