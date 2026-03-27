#!/bin/bash
# Install PVM Panel as a systemd service for 24/7 operation
# Run as root: bash install-service.sh

set -e

PANEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_FILE="$PANEL_DIR/pvm-panel.service"
SYSTEMD_FILE="/etc/systemd/system/pvm-panel.service"

echo "Installing PVM Panel service..."
echo "Panel directory: $PANEL_DIR"

# Update paths in service file
sed "s|/root/hvm|$PANEL_DIR|g" "$SERVICE_FILE" > "$SYSTEMD_FILE"

# Reload systemd
systemctl daemon-reload

# Enable and start
systemctl enable pvm-panel
systemctl start pvm-panel

echo ""
echo "PVM Panel service installed and started!"
echo ""
echo "Useful commands:"
echo "  systemctl status pvm-panel    # Check status"
echo "  systemctl restart pvm-panel   # Restart"
echo "  systemctl stop pvm-panel      # Stop"
echo "  journalctl -u pvm-panel -f    # Live logs"
echo "  tail -f $PANEL_DIR/hvm.log    # App logs"
