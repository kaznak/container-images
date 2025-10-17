#!/usr/bin/env bash
set -euo pipefail

# 必須: join token（k0s controller 側で発行した worker 用トークン）
#  - 環境変数 K0S_TOKEN で直接渡すか
#  - ファイルパスを K0S_TOKEN_FILE で渡す
if [[ -n "${K0S_TOKEN:-}" ]]; then
  TOKEN="${K0S_TOKEN}"
elif [[ -n "${K0S_TOKEN_FILE:-}" && -r "${K0S_TOKEN_FILE}" ]]; then
  TOKEN="$(cat "${K0S_TOKEN_FILE}")"
else
  echo "ERROR: K0S_TOKEN or K0S_TOKEN_FILE must be provided (k0s worker join token)" >&2
  exit 1
fi

# 任意: ノード名 / IP / ラベル / テイント / 追加引数
NODE_NAME="${NODE_NAME:-$(hostname)}"
NODE_IP="${NODE_IP:-}"
K0S_NODE_LABELS="${K0S_NODE_LABELS:-}"     # 例: "gpu=true,role=edge"
K0S_NODE_TAINTS="${K0S_NODE_TAINTS:-}"     # 例: "dedicated=gpu:NoSchedule"
K0S_EXTRA_ARGS="${K0S_EXTRA_ARGS:-}"       # そのまま k0s worker に渡す追加引数

# token を一時ファイルに落とす
mkdir -p /run
TOKEN_FILE="/run/k0s-worker.token"
printf "%s" "${TOKEN}" > "${TOKEN_FILE}"
chmod 600 "${TOKEN_FILE}"

# kubelet に渡す追加引数を組み立て
kubelet_args=()
[[ -n "${NODE_IP}"        ]] && kubelet_args+=("--node-ip=${NODE_IP}")
[[ -n "${K0S_NODE_LABELS}" ]] && kubelet_args+=("--node-labels=${K0S_NODE_LABELS}")
[[ -n "${K0S_NODE_TAINTS}" ]] && kubelet_args+=("--register-with-taints=${K0S_NODE_TAINTS}")

# k0s worker の引数
args=( "worker"
  "--data-dir" "${K0S_DATA_DIR}"
  "--token-file" "${TOKEN_FILE}"
  "--node-name" "${NODE_NAME}"
)

# kubelet-extra-args はスペース区切りで渡す
if (( ${#kubelet_args[@]} )); then
  args+=( "--kubelet-extra-args" "$(printf '%s ' "${kubelet_args[@]}")" )
fi

# 追加の k0s 引数（必要に応じて）
if [[ -n "${K0S_EXTRA_ARGS}" ]]; then
  # shellcheck disable=SC2206
  extra=( ${K0S_EXTRA_ARGS} )
  args+=( "${extra[@]}" )
fi

# cgroup v1 環境の最低限対応（あれば）
if [[ ! -f /sys/fs/cgroup/cgroup.controllers && -w /sys/fs/cgroup ]]; then
  mkdir -p /sys/fs/cgroup/{pids,cpuset,hugetlb,perf_event,freezer,devices,net_cls,net_prio,blkio,cpuacct,cpu,memory} || true
fi

echo ">>> launching: k0s ${args[*]/${TOKEN}/***}"
exec /usr/local/bin/k0s "${args[@]}"
