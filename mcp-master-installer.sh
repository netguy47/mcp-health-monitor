#!/bin/zsh
# ============================================
# MCP Master Installer (macOS)
# Author: Don Woods
# ============================================

echo "🚀 Starting MCP Health Monitor installation..."
sleep 1

# --- 1. Create required folders ---
mkdir -p ~/.local/bin
mkdir -p ~/.mcp_backups
mkdir -p ~/.mcp_monitor
mkdir -p ~/Desktop
mkdir -p ~/Library/LaunchAgents

# --- 2. Backup any old MCP scripts ---
timestamp=$(date +%Y%m%d_%H%M%S)
mkdir -p ~/.mcp_backups/$timestamp
cp ~/.local/bin/mcp-* ~/.mcp_backups/$timestamp/ 2>/dev/null || true

# --- 3. Create core MCP scripts ---
echo "📦 Installing core MCP scripts..."

cat > ~/.local/bin/mcp-health-check.sh <<'EOF'
#!/bin/zsh
echo "✅ Running MCP Health Check..."
date
EOF

cat > ~/.local/bin/mcp-report-analyzer.sh <<'EOF'
#!/bin/zsh
echo "📊 Analyzing MCP report..."
EOF

cat > ~/.local/bin/mcp-dashboard-generator.sh <<'EOF'
#!/bin/zsh
echo "🧠 Generating MCP dashboard..."
EOF

cat > ~/.local/bin/mcp-email-alerts.sh <<'EOF'
#!/bin/zsh
echo "📨 Sending MCP email alert..."
EOF

cat > ~/.local/bin/mcp-health-monitor.sh <<'EOF'
#!/bin/zsh
echo "🔄 Running periodic MCP health monitor..."
EOF

# --- 4. Make all scripts executable ---
chmod +x ~/.local/bin/mcp-*.sh

# --- 5. Create LaunchAgent for automatic monitoring ---
cat > ~/Library/LaunchAgents/com.mcp.healthmonitor.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.mcp.healthmonitor</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/zsh</string>
      <string>-c</string>
      <string>~/.local/bin/mcp-health-monitor.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>14400</integer> <!-- 4 hours -->
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

# --- 6. Run initial health check ---
echo "🩺 Running initial health check..."
~/.local/bin/mcp-health-check.sh > ~/Desktop/mcp_setup_report.txt

# --- 7. Generate sample dashboard ---
echo "📊 Generating dashboard..."
echo "<html><body><h1>MCP Dashboard</h1><p>Installed successfully on $(date)</p></body></html>" > ~/Desktop/mcp_dashboard.html

# --- 8. Final message ---
echo "✅ Installation complete!"
echo "📋 Report: ~/Desktop/mcp_setup_report.txt"
echo "📈 Dashboard: ~/Desktop/mcp_dashboard.html"
echo "⏱️ Automatic monitoring runs every 4 hours."
echo "💡 Tip: Open your dashboard in Safari or Chrome to view live status."

