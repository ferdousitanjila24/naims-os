#!/usr/bin/env bash
# অটো-ডিপ্লয় বন্ধ
cd "$(dirname "$0")" || exit 1
PIDFILE=".auto-deploy.pid"

if [ -f "$PIDFILE" ]; then
  PID="$(cat "$PIDFILE")"
  if kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null
    pkill -P "$PID" 2>/dev/null
    echo "🛑 অটো-ডিপ্লয় বন্ধ হয়েছে (PID $PID)"
  else
    echo "ℹ️  প্রসেস চলছিল না"
  fi
  rm -f "$PIDFILE"
else
  if pkill -f "watch-deploy.sh" 2>/dev/null; then
    echo "🛑 অটো-ডিপ্লয় বন্ধ হয়েছে"
  else
    echo "ℹ️  অটো-ডিপ্লয় চলছিল না"
  fi
fi
