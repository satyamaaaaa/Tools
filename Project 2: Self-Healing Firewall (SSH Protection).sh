#!/bin/bash

echo "=============================================="
echo " Project 2: Self-Healing Firewall (SSH Protection)"
echo "=============================================="
echo

# Root check
if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root (sudo)"
    exit 1
fi

THRESHOLD=3
TEMP_LOG="/tmp/ssh_failed.log"
BLOCKED=0   # success flag

echo "[*] Collecting SSH failed login attempts..."

journalctl -u ssh --no-pager 2>/dev/null | grep "Failed password" > "$TEMP_LOG"

# No attacks found → clean exit (NOT success)
if [[ ! -s "$TEMP_LOG" ]]; then
    echo "[✓] No failed SSH login attempts found"
    echo "[✓] System is clean — firewall unchanged"
    rm -f "$TEMP_LOG"
    exit 0
fi

echo "[+] Failed login attempts detected"
echo

grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$TEMP_LOG" | \
sort | uniq -c | while read COUNT IP
do
    echo "[*] IP: $IP | Attempts: $COUNT"

    if [[ "$COUNT" -ge "$THRESHOLD" ]]; then
        if iptables -C INPUT -s "$IP" -j DROP 2>/dev/null; then
            echo "    [-] IP already blocked"
        else
            iptables -I INPUT -s "$IP" -j DROP
            echo "    [!] IP BLOCKED"
            BLOCKED=1
        fi
    else
        echo "    [-] Below threshold, not blocked"
    fi
done

rm -f "$TEMP_LOG"

# Print completion ONLY if blocking happened
if [[ "$BLOCKED" -eq 1 ]]; then
    echo
    echo "=============================================="
    echo " ✅ Project 2 Completed Successfully"
    echo " Malicious IPs were detected and blocked"
    echo "=============================================="
fi
