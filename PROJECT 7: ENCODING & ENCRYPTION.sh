echo "=============================================="
echo "        PROJECT 7: ENCODING & ENCRYPTION       "
echo "=============================================="
echo

# -------- Ask user for number of inputs --------
read -p "Enter number of names: " COUNT

declare -a NAMES

for (( i=1; i<=COUNT; i++ ))
do
  read -p "Enter name $i: " NAME
  NAMES+=("$NAME")
done

echo

# ---------- AES KEY ----------
AES_PASS="mysecretkey"

# ---------- RSA KEY GENERATION ----------
openssl genrsa -out private.pem 2048 >/dev/null 2>&1
openssl rsa -in private.pem -pubout -out public.pem >/dev/null 2>&1

for NAME in "${NAMES[@]}"
do
  echo "========== $NAME =========="

  # -------- Base Encoding --------
  echo "Base64: $(echo -n "$NAME" | base64)"
  echo "Base32: $(echo -n "$NAME" | base32)"
  echo "Base16: $(echo -n "$NAME" | xxd -p)"

  echo "Decoded Base64: $(echo -n "$NAME" | base64 | base64 -d)"
  echo "Decoded Base32: $(echo -n "$NAME" | base32 | base32 -d)"
  echo "Decoded Base16: $(echo -n "$NAME" | xxd -p | xxd -r -p)"

  # -------- Hashing --------
  echo "MD5: $(echo -n "$NAME" | openssl dgst -md5 | awk '{print $2}')"
  echo "SHA1: $(echo -n "$NAME" | openssl dgst -sha1 | awk '{print $2}')"
  echo "SHA256: $(echo -n "$NAME" | openssl dgst -sha256 | awk '{print $2}')"
  echo "Hash Decryption: NOT POSSIBLE"

  # -------- AES Encryption --------
  AES_ENC=$(echo -n "$NAME" | openssl enc -aes-256-cbc -a -salt -pass pass:$AES_PASS)
  AES_DEC=$(echo "$AES_ENC" | openssl enc -aes-256-cbc -a -d -pass pass:$AES_PASS)

  echo "AES Encrypted: $AES_ENC"
  echo "AES Decrypted: $AES_DEC"

  # -------- RSA Encryption --------
  RSA_ENC=$(echo -n "$NAME" | openssl rsautl -encrypt -pubin -inkey public.pem | base64)
  RSA_DEC=$(echo "$RSA_ENC" | base64 -d | openssl rsautl -decrypt -inkey private.pem)

  echo "RSA Encrypted: $RSA_ENC"
  echo "RSA Decrypted: $RSA_DEC"

  echo
done

echo "=============================================="
echo "      PROJECT 7 COMPLETED SUCCESSFULLY         "
echo "=============================================="
