#!/bin/bash

echo "=============================================="
echo " Project 4: Linux Forensics Evidence Collector"
echo "=============================================="
echo

# Root check (mandatory for full forensic visibility)
if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root (sudo) for complete forensic data"
    exit 1
fi

DIR="forensics_$(date +%F_%H-%M)"
SUCCESS=1   # assume success

mkdir "$DIR" || SUCCESS=0

echo "[+] Collecting running processes"
ps -ef > "$DIR/processes.txt" || SUCCESS=0

echo "[+] Collecting open ports & network services"
netstat -tulnp > "$DIR/open_ports.txt" || SUCCESS=0

echo "[+] Collecting logged-in users"
who > "$DIR/logged_users.txt" || SUCCESS=0

echo "[+] Collecting open files"
lsof > "$DIR/open_files.txt" || SUCCESS=0

# Package evidence only if everything succeeded
if [[ "$SUCCESS" -eq 1 ]]; then
    tar -czf "$DIR.tar.gz" "$DIR" || SUCCESS=0
    rm -rf "$DIR"
fi

# Print completion ONLY on success
if [[ "$SUCCESS" -eq 1 ]]; then
    echo
    echo "=============================================="
    echo " ✅ Project 4 Completed Successfully"
    echo " Forensics evidence saved as:"
    echo " $DIR.tar.gz"
    echo "=============================================="
else
    echo
    echo "[!] Project 4 failed — incomplete forensic evidence"
    exit 1
fi
