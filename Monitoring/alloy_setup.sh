sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y alloy

# Dont forget to change loki and prometheus IP for the config file below

cat <<EOF > /etc/alloy/config.alloy
// Metrics scraping and remote write to Prometheus

prometheus.remote_write "default" {
  endpoint {
    url = "http://PrometheusIP:9090/api/v1/write"
  }
}

prometheus.scrape "metrics_5000" {
  targets = [{
    __address__ = "localhost:5000",
    __metrics_path__ = "/metrics",
  }]
  forward_to = [prometheus.remote_write.default.receiver]
}

prometheus.scrape "metrics_default" {
  targets = [{
    __address__ = "localhost:8080",  // Adjust port if different; assuming 8080 for /metrics endpoint
    __metrics_path__ = "/metrics",
  }]
  forward_to = [prometheus.remote_write.default.receiver]
}

// Log collection from files and push to Loki

local.file_match "titan_logs" {
  path_targets = [{
    __path__ = "/var/log/titan/*.log",
    job      = "titan",
    hostname = constants.hostname,
  }]
  sync_period = "5s"
}

loki.source.file "log_scrape" {
  targets       = local.file_match.titan_logs.targets
  forward_to    = [loki.write.loki.receiver]
  tail_from_end = true
}

loki.write "loki" {
  endpoint {
    url = "http://LokiIP:3100/loki/api/v1/push"
  }
}
EOF

cat <<EOF > /etc/default/alloy
## Path:
## Description: Grafana Alloy settings
## Type:        string
## Default:     ""
## ServiceRestart: alloy
#
# Command line options for Alloy.
#
# The configuration file holding the Alloy config.
CONFIG_FILE="/etc/alloy/config.alloy"

# User-defined arguments to pass to the run command.
CUSTOM_ARGS="--server.http.listen-addr=0.0.0.0:12345"

# Restart on system upgrade. Defaults to true.
RESTART_ON_UPGRADE=true
EOF

systemctl restart alloy
systemctl enable alloy
sleep 40
systemctl status alloy --no-pager
echo "✅ Alloy setup completed."

# Configure the firewall

# Install ufw if not present
apt install -y ufw

# Allow SSH (port 22), Node Exporter (9100), Loki (3100), and Flask app (80)
echo "Allowing SSH (22), Node Exporter (9100), Loki (3100), and Flask app (80) through firewall..."
ufw allow 22/tcp
ufw allow 9100/tcp
ufw allow 3100/tcp
ufw allow 5000/tcp
ufw allow 12345/tcp


# Enable UFW (force yes)
echo "Enabling UFW..."
echo "y" | ufw enable
ufw status verbose

echo "✅ UFW firewall configured."
