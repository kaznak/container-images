# 例: v1.34 系なら v1.34.x+k0s.y を指定
ARG K0S_VERSION=v1.34.1+k0s.0
ARG ARCH=amd64

FROM alpine:3.20
ARG K0S_VERSION

# 便利ツール（ヘルスチェックやデバッグ用）
RUN apk add --no-cache bash iproute2 iptables ethtool curl ca-certificates tini util-linux coreutils

# k0s バイナリを取得
RUN curl -fsSL -o /usr/local/bin/k0s \
      "https://github.com/k0sproject/k0s/releases/download/${K0S_VERSION}/k0s-linux-${ARCH}" \
 && chmod +x /usr/local/bin/k0s

# エントリポイント
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

# ランタイム用ディレクトリ（コンテナ外に永続化推奨）
VOLUME ["/var/lib", "/var/log"]

# 環境変数
ENV K0S_DATA_DIR=/var/lib/k0s

# kubelet ローカル healthz（10248）をチェック
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=5 \
  CMD curl -sf http://127.0.0.1:10248/healthz || exit 1

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
