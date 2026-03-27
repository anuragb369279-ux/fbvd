#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/pvm.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        echo "PVM Panel stopped (PID $PID)"
    else
        echo "PVM Panel not running"
    fi
    rm -f "$PID_FILE"
else
    echo "No PID file found. Trying pkill..."
    pkill -f "python3 hvm.py" && echo "Stopped" || echo "Not running"
fi
