# node apploader

A simple node.js app loader that clones a git repository, build and run the app.

Set a environment variable `GIT_REPOSITORY` to specify the git repository.
Mount a ssh key to `/home/node/.ssh/id_rsa` to access the private repository.

## Example

### Simple example

An example on kubernetes deployment. It loads ssh keys from the secret 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: www-example-com
  labels:
    app: www-example-com
spec:
  replicas: 1
  selector:
    matchLabels:
      app: www-example-com
  template:
    metadata:
      labels:
        app: www-example-com
    spec:
      containers:
        - name: www-example-com
          image: ghcr.io/kaznak/node-apploader:20-alpine
          imagePullPolicy: Always
          envFrom:
            - secretRef:
                name: www-example-com-config
          resources:
            requests: {}
            limits: {}
          volumeMounts:
            - mountPath: /home/node/.ssh/id_rsa
              name: sshkey-volume
              subPath: id_rsa
              readOnly: true
          # https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
          livenessProbe:
            httpGet:
              path: /healthz
              port: 3000
            initialDelaySeconds: 300
            periodSeconds: 5
          readinessProbe:
            httpGet:
              path: /healthz
              port: 3000
            initialDelaySeconds: 30
            periodSeconds: 5
      securityContext:
        fsGroup: 1001
      volumes:
        - name: sshkey-volume
          secret:
            secretName: www-example-com-sshkey
```

node-apploader does clone, build and run the app in the git repository.
Thus if the initial liveness probe starts too early, the cluster may restart the pod continuously.
The `livenessProbe.initialDelaySeconds` must be set to a proper value.

### Full Example

It based on [kustomize](https://kubectl.docs.kubernetes.io/references/kustomize/) with [prometheus operator](https://github.com/prometheus-operator/prometheus-operator).

Replace following strings to your own:

- `www.example.com`
- `www-example-com`
- `WwwExampleCom`

#### kustomization.yaml

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: svc-www-example-com

resources:
- deployment.yaml
- service.yaml
# running service monitor in not the monitoring namespace requires cross namespace configuration that is complicated
# use probe resource instead of service monitor
- probe.yaml
- prometheusrule.yaml

secretGenerator:
- name: www-example-com-config
  envs:
    - .secrets
  type: Opaque
- name: www-example-com-sshkey
  files:
    - id_rsa
    - id_rsa.pub
  type: Opaque
```

#### .secrets.examle

```env
GIT_REPOSITORY=
GA_TRACKING_ID=
SENTRY_AUTH_TOKEN=
SENTRY_DSN=
```

#### deployment.yaml

The yaml file in the simple example.

#### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: www-example-com
spec:
  selector:
    app: www-example-com
  ports:
  - port: 80
    targetPort: 3000
```

#### probe.yaml

```yaml
kind: Probe
apiVersion: monitoring.coreos.com/v1
metadata:
  name: blackbox-www-example-com
spec:
  interval: 60s
  module: http_2xx
  prober:
    url: blackbox-exporter.monitoring.svc.cluster.local:19115
  targets:
    staticConfig:
      static:
      - https://www.example.com/healthz
```

#### prometheusrule.yaml

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: pod-ready-check
spec:
  groups:
  - name: pod-ready-check
    rules:
    - alert: WwwExampleComPodsNotReady
      expr: |
        sum by(namespace, pod) (kube_pod_status_phase{namespace="svc-www-example-com", pod=~"www-example-com-.*", phase="Running"}) 
        != count by(namespace, pod) (kube_pod_status_ready{namespace="svc-www-example-com", pod=~"www-example-com-.*", condition="true"})
      for: 5m
      labels:
        severity: critical
      annotations:
        summary: "HTTP server pods not ready in namespace {{ $labels.namespace }}"
        description: "One or more pods are not in Ready state in namespace {{ $labels.namespace }}."
--- 
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: web-alive-monitoring
  namespace: monitoring
spec:
  groups:
  - name: web-alive
    rules:
    - alert: WwwExampleComWebsiteDown
      expr: probe_success{instance="https://www.example.com/healthz", job="probe/svc-www-example-com/blackbox-www-example-com", namespace="svc-www-example-com"} == 0
      for: 5m
      labels:
        severity: critical
      annotations:
        summary: "Website www.example.com is down"
        description: "The website www.example.com has been down for more than 5 minutes."
```
