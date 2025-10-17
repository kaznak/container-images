#!/usr/bin/env bash
set -euo pipefail

# Ensure required envs
: "${K3S_URL:?K3S_URL must be set, e.g. https://<server>:6443}"
# Token via env or file
if [[ -n "${K3S_TOKEN:-}" ]]; then
  TOKEN="${K3S_TOKEN}"
elif [[ -n "${K3S_TOKEN_FILE:-}" && -r "${K3S_TOKEN_FILE}" ]]; then
  TOKEN=$(cat "${K3S_TOKEN_FILE}")
else
  echo "ERROR: K3S_TOKEN or K3S_TOKEN_FILE must be provided" >&2
  exit 1
fi

NODE_NAME=${NODE_NAME:-$(hostname)}
NODE_IP=${NODE_IP:-}
K3S_CNI=${K3S_CNI:-auto}     # auto|flannel|none
K3S_NODE_LABELS=${K3S_NODE_LABELS:-}
K3S_NODE_TAINTS=${K3S_NODE_TAINTS:-}
K3S_EXTRA_ARGS=${K3S_EXTRA_ARGS:-}

args=("agent" "--server" "${K3S_URL}" "--token" "${TOKEN}" "--node-name" "${NODE_NAME}")

if [[ -n "${NODE_IP}" ]]; then
  args+=("--node-ip" "${NODE_IP}")
fi

# CNI handling
case "${K3S_CNI}" in
  auto)
    # Do nothing; follow server-side defaults (typically flannel)
    ;;
  flannel)
    # Explicitly use flannel; useful if server allows it
    args+=("--flannel-backend=vxlan")
    ;;
  none)
    # Disable k3s CNI on the agent to let an external CNI (e.g. Cilium) manage dataplane
    args+=("--flannel-backend=none" "--disable-network-policy")
    ;;
  *)
    echo "WARN: Unknown K3S_CNI='${K3S_CNI}', falling back to 'auto'" >&2
    ;;
esac

# Labels/taints
if [[ -n "${K3S_NODE_LABELS}" ]]; then
  IFS=',' read -ra lbls <<< "${K3S_NODE_LABELS}"
  for l in "${lbls[@]}"; do
    [[ -n "$l" ]] && args+=("--node-label" "$l")
  done
fi
if [[ -n "${K3S_NODE_TAINTS}" ]]; then
  IFS=',' read -ra tnts <<< "${K3S_NODE_TAINTS}"
  for t in "${tnts[@]}"; do
    [[ -n "$t" ]] && args+=("--node-taint" "$t")
  done
fi

# Extra passthrough flags
if [[ -n "${K3S_EXTRA_ARGS}" ]]; then
  # shellcheck disable=SC2206
  extra=( ${K3S_EXTRA_ARGS} )
  args+=("${extra[@]}")
fi

# Best-effort cgroup mounts when running without explicit host mounts (still
# requires privileged container). Safe to no-op if already present.
if [[ ! -f /sys/fs/cgroup/cgroup.controllers && -w /sys/fs/cgroup ]]; then
  # cgroup v1 fallback layout
  mkdir -p /sys/fs/cgroup/{pids,cpuset,hugetlb,perf_event,freezer,devices,net_cls,net_prio,blkio,cpuacct,cpu,memory}
fi

# Print final command (redacted token)
printf ">>> launching: k3s %q\n" "${args[@]//${TOKEN}/***}"

# --- GPU auto device-plugin as static Pod(s) ---------------------------------
# If NVIDIA/AMD/Intel devices are detected on this node, drop a static Pod
# manifest into k3s' kubelet staticPodPath so the device plugin starts locally
# without requiring cluster-admin RBAC or DaemonSet installation.
STATIC_POD_DIR="/var/lib/rancher/k3s/agent/pod-manifests"
mkdir -p "$STATIC_POD_DIR"

emit_static_pod() {
  local name="$1"; shift
  local content="$1"; shift || true
  local path="$STATIC_POD_DIR/${name}.yaml"
  if [[ ! -f "$path" ]]; then
    echo ">>> enabling static device-plugin pod: $name -> $path"
    printf '%s
' "$content" > "$path"
  else
    echo "=== static device-plugin pod already present: $path"
  fi
}

if [[ -e /dev/nvidiactl || -e /dev/nvidia0 ]]; then
  emit_static_pod nvidia-gpu-device-plugin
fi

# AMD (ROCm) or Intel (DRI) detection via /dev/dri presence
if [[ -d /dev/dri ]]; then
  # Intel GPU plugin example (comment out if using AMD)
  emit_static_pod intel-gpu-device-plugin
fi

# exec k3s with all accumulated args
exec /bin/k3s "${args[@]}"
