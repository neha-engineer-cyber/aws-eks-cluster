#!/bin/bash
set -e
set -v
set -u

# grab instance-id to use with eks label
TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=`curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id`

mkdir /nodeadm-config
touch nodeconfig.yaml

tee << EOF > /nodeadm-config/nodeconfig.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster-name}
    apiServerEndpoint: ${api-endpoint}
    certificateAuthority: ${endpoint-ca}
    cidr: 10.100.0.0/16
  kubelet:
    config:
      shutdownGracePeriod: "30s"
      shutdownGracePeriodCriticalPods: "10s"
    flags:
    - --node-labels=workload=$WORKLOAD_LABEL,instanceid=$INSTANCE_ID
EOF

nodeadm init --config-source file://nodeadm-config/nodeconfig.yaml