#!/bin/bash
# PVM Panel - Persistent startup script
# Run this to start the panel as a background process that survives terminal close

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/pvm.pid"
LOG_FILE="$SCRIPT_DIR/hvm.log"

# Kill existing instance if running
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Stopping existing PVM Panel (PID $OLD_PID)..."
        kill "$OLD_PID"
        sleep 2
    fi
    rm -f "$PID_FILE"
fi

echo "Starting PVM Panel..."
cd "$SCRIPT_DIR"

# Start with nohup so it survives terminal close
nohup python3 hvm.py >> "$LOG_FILE" 2>&1 &
PID=$!
echo $PID > "$PID_FILE"

echo "PVM Panel started (PID $PID)"
echo "Logs: $LOG_FILE"
echo "To stop: kill \$(cat $PID_FILE)"
