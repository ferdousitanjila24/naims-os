#!/usr/bin/env bash
# ============================================================
#  একবারের সেটআপ — Vercel লগইন + প্রজেক্ট লিংক + টেস্ট ডিপ্লয়
#  চালান:  bash setup-auto-deploy.sh
# ============================================================
set -uo pipefail
cd "$(dirname "$0")" || exit 1

echo "🔧 Naim's OS — অটো-ডিপ্লয় সেটআপ"
echo "   (গ্লোবাল ইনস্টল লাগবে না — npx নিজেই Vercel CLI নামিয়ে নেবে)"
echo ""

# ---------- ১) লগইন ----------
WHO="$(npx --yes vercel@latest whoami 2>&1 || true)"
if printf '%s' "$WHO" | grep -qi "logged out"; then
  echo "🔐 ১/৩ — Vercel-এ লগইন করুন (ব্রাউজার/টার্মিনালে কোড দেখাবে)…"
  npx --yes vercel@latest login || { echo "❌ লগইন ব্যর্থ"; exit 1; }
else
  echo "✅ ১/৩ — আগেই লগইন করা আছে"
fi

# ---------- ২) লিংক ----------
if [ -f .vercel/project.json ]; then
  echo "✅ ২/৩ — প্রজেক্ট আগেই লিংক করা আছে"
else
  echo "🔗 ২/৩ — এই ফোল্ডারটা আপনার পুরনো প্রজেক্টের সাথে লিংক করুন"
  echo "   ⚠️  লিস্ট থেকে  naims-os  বাছুন — নতুন প্রজেক্ট বানাবেন না!"
  npx --yes vercel@latest link || { echo "❌ লিংক ব্যর্থ"; exit 1; }
fi

# ---------- ৩) টেস্ট ----------
echo ""
echo "🚀 ৩/৩ — টেস্ট ডিপ্লয় চলছে…"
if bash deploy.sh; then
  echo ""
  echo "🎉 সব রেডি! এখন চালু করুন:   bash start-auto.sh"
  echo "   এরপর index.html সেভ করলেই অটো ডিপ্লয় হবে।"
else
  echo ""
  echo "⚠️  ডিপ্লয় হয়নি — উপরের এরর দেখুন, তারপর আবার চেষ্টা করুন।"
  exit 1
fi
