#!/usr/bin/env bash
# ============================================================
#  অটো-ডিপ্লয় ব্যাকগ্রাউন্ডে চালু (টার্মিনাল বন্ধ করলেও চলবে)
#  চালু:  bash start-auto.sh
#  বন্ধ:  bash stop-auto.sh
# ============================================================
cd "$(dirname "$0")" || exit 1
PIDFILE=".auto-deploy.pid"
OUT="auto-deploy.out"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "ℹ️  অটো-ডিপ্লয় আগে থেকেই চলছে (PID $(cat "$PIDFILE"))"
  echo "   লগ দেখুন:  tail -f \"$OUT\""
  exit 0
fi

if ! command -v node >/dev/null 2>&1; then
  echo "❌ Node.js পাওয়া যায়নি — https://nodejs.org থেকে ইনস্টল করুন"
  exit 1
fi

nohup bash watch-deploy.sh >> "$OUT" 2>&1 &
echo $! > "$PIDFILE"
sleep 1
echo "✅ অটো-ডিপ্লয় চালু — PID $(cat "$PIDFILE")"
echo "   এখন index.html সেভ করলেই নিজে নিজে ডিপ্লয় হবে"
echo "   লগ:    tail -f \"$OUT\""
echo "   বন্ধ:  bash stop-auto.sh"
