#!/usr/bin/env bash
# ============================================================
#  Naim's OS — এক কমান্ডে Vercel Production ডিপ্লয়
#  ব্যবহার:  bash deploy.sh
#  টেস্ট:    DRY_RUN=1 bash deploy.sh   (আসল ডিপ্লয় হবে না)
# ============================================================
set -uo pipefail
cd "$(dirname "$0")" || exit 1

# টোকেন: env দিয়ে, নাহলে .vercel-token ফাইল দিয়ে (ফাইলটা git-এ যায় না)
if [ -z "${VERCEL_TOKEN:-}" ] && [ -f .vercel-token ]; then
  VERCEL_TOKEN="$(tr -d '[:space:]' < .vercel-token)"
fi

ARGS=(deploy --prod --yes)
[ -n "${VERCEL_TOKEN:-}" ] && ARGS+=(--token "$VERCEL_TOKEN")

STAMP="$(date '+%Y-%m-%d %H:%M:%S')"
SIZE="$(wc -c < index.html | tr -d ' ')"

if [ "${DRY_RUN:-}" = "1" ]; then
  echo "🧪 [$STAMP] DRY RUN — index.html ($SIZE bytes) ডিপ্লয় করা হতো"
  exit 0
fi

echo "🚀 [$STAMP] Vercel-এ ডিপ্লয় শুরু… (index.html $SIZE bytes)"
npx --yes vercel@latest "${ARGS[@]}" 2>&1 | tee -a deploy.log
STATUS=${PIPESTATUS[0]}

if [ "$STATUS" -eq 0 ]; then
  echo "✅ [$STAMP] ডিপ্লয় সফল → https://naims-os.vercel.app"
else
  echo "❌ [$STAMP] ডিপ্লয় ব্যর্থ (exit $STATUS)"
  echo "   👉 একবার লগইন/লিংক করা আছে কি না দেখুন:  npx vercel login  •  npx vercel link"
fi
exit "$STATUS"
