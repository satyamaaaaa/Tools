#!/bin/bash

echo "=============================================="
echo "      PROJECT 8:  IP CHAIN CONVERSION TOOL               "
echo "=============================================="
echo

read -p "Enter IPv4 Address (e.g. 192.168.1.154): " IP
echo

IFS='.' read -r o1 o2 o3 o4 <<< "$IP"
OCTETS=($o1 $o2 $o3 $o4)

# ---------- function: decimal → 8-bit binary ----------
dec_to_bin() {
  local n=$1
  local bin=""
  for ((i=7; i>=0; i--)); do
    (( (n >> i) & 1 )) && bin+="1" || bin+="0"
  done
  echo "$bin"
}

# ---------- Step 1: IP → Binary ----------
BIN_LIST=()
for o in "${OCTETS[@]}"; do
  BIN_LIST+=( "$(dec_to_bin "$o")" )
done

echo "Step 1: IP → Binary"
echo "${BIN_LIST[*]}"
echo

# ---------- Step 2: Binary → Hexadecimal ----------
HEX_LIST=()
for o in "${OCTETS[@]}"; do
  HEX_LIST+=( "$(printf "%02X" "$o")" )
done

echo "Step 2: Binary → Hexadecimal"
echo "${HEX_LIST[*]}"
echo

# ---------- Step 3: Hexadecimal → Quad ----------
echo "Step 3: Hexadecimal → Quad"
echo "$IP"
echo

# ---------- Step 4: Binary → Octal ----------
OCT_LIST=()
for o in "${OCTETS[@]}"; do
  OCT_LIST+=( "$(printf "%o" "$o")" )
done

echo "Step 4: Binary → Octal"
echo "${OCT_LIST[*]}"
echo

# ---------- Step 5: Octal → Binary ----------
BIN_BACK=()
for o in "${OCT_LIST[@]}"; do
  dec=$((8#$o))
  BIN_BACK+=( "$(dec_to_bin "$dec")" )
done

echo "Step 5: Octal → Binary"
echo "${BIN_BACK[*]}"
echo

echo "=============================================="
echo "        CONVERSION COMPLETED SUCCESSFULLY     "
echo "=============================================="
