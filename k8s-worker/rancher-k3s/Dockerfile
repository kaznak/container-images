
# Pin to a known-good k3s release; adjust as needed.
ARG K3S_TAG=v1.34.1-k3s1
FROM rancher/k3s:${K3S_TAG}

# Minimal shell/tools for healthchecks & debugging
RUN apk add --no-cache bash tini iproute2 iptables ethtool curl ca-certificates

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Data dirs (backed by volumes or bind mounts at runtime)
VOLUME ["/var/lib", "/var/log"]

# Helpful defaults
ENV K3S_DATA_DIR=/var/lib/rancher/k3s \
    CONTAINERD_ROOT=/var/lib/containerd \
    K3S_KUBECONFIG_MODE=644

# Healthcheck: kubelet local healthz (kubelet listens 10248 by default)
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=5 \
  CMD curl -sf http://127.0.0.1:10248/healthz || exit 1

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
