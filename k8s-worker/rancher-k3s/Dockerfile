# Pin to the server-side version (example: v1.34.1-k3s1)
ARG K3S_TAG=v1.34.1-k3s1
FROM rancher/k3s:${K3S_TAG}

# entrypoint を実行可能でコピー（Docker 20.10+ の --chmod を使用）
RUN mkdir /entrypoint.d
COPY --chmod=0755 entrypoint.sh /entrypoint.d/entrypoint.sh
COPY k8s-device-plugins /entrypoint.d/k8s-device-plugins

# データディレクトリ（ランタイムで volume/bind 推奨）
VOLUME ["/var/lib", "/var/log"]

# 環境変数
ENV K3S_DATA_DIR=/var/lib/rancher/k3s \
    CONTAINERD_ROOT=/var/lib/containerd \
    K3S_KUBECONFIG_MODE=644

# curl 等が無いので、ファイル存在でヘルスチェック
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=5 \
  CMD test -f /var/lib/rancher/k3s/agent/kubelet.pid || exit 1

ENTRYPOINT ["/entrypoint.d/entrypoint.sh"]
