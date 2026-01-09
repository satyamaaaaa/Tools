#!/bin/bash

echo "=============================================="
echo " Project 1: Secure Backup Automator (Encrypted Backup)"
echo "=============================================="
echo

# MUST BE RUN AS ROOT
if [[ $EUID -ne 0 ]]; then
  echo "[!] Please run as root (sudo)"
  exit 1
fi

SOURCE_DIR="/etc /home"
BACKUP_DIR="/home/kali/secure_backups"
DATE=$(date +"%Y-%m-%d_%H-%M")
ARCHIVE="backup_$DATE.tar.gz"
ENCRYPTED="$ARCHIVE.gpg"
PASSPHRASE="StrongBackupPass123!"   # change this

mkdir -p "$BACKUP_DIR"

echo "[+] Creating compressed backup..."
tar --ignore-failed-read -czf "/tmp/$ARCHIVE" $SOURCE_DIR
if [[ $? -ne 0 ]]; then
  echo "[!] Backup creation failed"
  exit 1
fi

echo "[+] Encrypting backup (non-interactive)..."
gpg --batch --yes --passphrase "$PASSPHRASE" -c "/tmp/$ARCHIVE"
if [[ $? -ne 0 ]]; then
  echo "[!] Encryption failed"
  exit 1
fi

mv "/tmp/$ENCRYPTED" "$BACKUP_DIR"
rm "/tmp/$ARCHIVE"

echo
echo "=============================================="
echo " ✅ Project 1 Completed Successfully"
echo " Encrypted backup stored at:"
echo " $BACKUP_DIR/$ENCRYPTED"
echo "=============================================="
