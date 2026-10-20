#!/usr/bin/env bash
# ============================================================
#  GitHub রুট: সেভ করলেই অটো কমিট + পুশ → Vercel নিজে ডিপ্লয় করবে
#  আগে একবার:  git remote add origin git@github.com:USER/naims-os.git
#  চালু:  bash git-auto-push.sh
# ============================================================
set -uo pipefail
cd "$(dirname "$0")" || exit 1

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ এখানে git রিপো নেই — README-DEPLOY.md দেখুন"
  exit 1
fi
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "❌ GitHub রিমোট (origin) সেট করা নেই:"
  echo "   git remote add origin git@github.com:USER/naims-os.git"
  exit 1
fi

echo "👀 git-auto-push চালু — ফাইল বদলালে ৫ সেকেন্ডে অটো কমিট + পুশ (Ctrl+C দিয়ে বন্ধ)"
while true; do
  sleep 5
  if [ -n "$(git status --porcelain)" ]; then
    sleep 2
    git add -A
    git commit -m "auto update: $(date '+%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1 || true
    if git push -q origin HEAD 2>>auto-deploy.out; then
      echo "✅ [$(date '+%H:%M:%S')] পুশ হয়েছে — Vercel অটো ডিপ্লয় করবে"
    else
      echo "❌ [$(date '+%H:%M:%S')] পুশ ব্যর্থ — auto-deploy.out দেখুন"
    fi
  fi
done
