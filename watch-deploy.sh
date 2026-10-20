#!/usr/bin/env bash
# ============================================================
#  index.html বদলালেই অটো Vercel-এ ডিপ্লয়
#  চালু:  bash watch-deploy.sh        (Ctrl+C দিয়ে বন্ধ)
#  DRY_RUN=1 bash watch-deploy.sh     (শুধু টেস্ট)
# ============================================================
cd "$(dirname "$0")" || exit 1

FILE="index.html"
hash_file() {
  if command -v md5 >/dev/null 2>&1; then md5 -q "$1"; else md5sum "$1" | awk '{print $1}'; fi
}

if [ ! -f "$FILE" ]; then echo "❌ $FILE পাওয়া যায়নি"; exit 1; fi

LAST="$(hash_file "$FILE")"
echo "👀 ওয়াচার চালু — '$FILE' বদলালেই ডিপ্লয় হবে (চেক প্রতি ৪ সেকেন্ড, DRY_RUN=${DRY_RUN:-0})"
echo "   বন্ধ করতে Ctrl+C"

while true; do
  sleep 4
  [ -f "$FILE" ] || continue
  CUR="$(hash_file "$FILE")"
  if [ "$CUR" != "$LAST" ]; then
    sleep 3                      # ডিবাউন্স: ফাইল লেখা শেষ হওয়ার অপেক্ষা
    LAST="$(hash_file "$FILE")"
    echo "─────────────"
    echo "🔔 [$(date '+%H:%M:%S')] পরিবর্তন ধরা পড়েছে — ডিপ্লয় শুরু"
    DRY_RUN="${DRY_RUN:-}" bash deploy.sh
  fi
done
