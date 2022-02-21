#!/bin/sh
# SERVICE is the name of the Vault service in Kubernetes.
# It does not have to match the actual running service, though it may help for consistency.
SERVICE=vault

SERVICE1=vault-active
SERVICE2=vault-standby
SERVICE3=vault-internal
SERVICE4=vault-ui

# NAMESPACE where the Vault service is running.
NAMESPACE=vault

# SECRET_NAME to create in the Kubernetes secrets store.
SECRET_NAME=tls-server

SECRET_NAME2=tls-ca

# TMPDIR is a temporary working directory.
TMPDIR=/tmp


openssl genrsa -out ${TMPDIR}/vault.key 2048

cat <<EOF >${TMPDIR}/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SERVICE}
DNS.2 = ${SERVICE}.${NAMESPACE}
DNS.3 = ${SERVICE}.${NAMESPACE}.svc
DNS.4 = ${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.5 = vault-0.${SERVICE}
DNS.6 = vault-0.${SERVICE}.${NAMESPACE}
DNS.7 = vault-0.${SERVICE}.${NAMESPACE}.svc
DNS.8 = vault-0.${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.9 = vault-1.${SERVICE}
DNS.10 = vault-1.${SERVICE}.${NAMESPACE}
DNS.11 = vault-1.${SERVICE}.${NAMESPACE}.svc
DNS.12 = vault-1.${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.13 = vault-2.${SERVICE}
DNS.14 = vault-2.${SERVICE}.${NAMESPACE}
DNS.15 = vault-2.${SERVICE}.${NAMESPACE}.svc
DNS.16 = vault-2.${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.17 = vault-3.${SERVICE}
DNS.18 = vault-3.${SERVICE}.${NAMESPACE}
DNS.19 = vault-3.${SERVICE}.${NAMESPACE}.svc
DNS.20 = vault-3.${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.21 = vault-4.${SERVICE}
DNS.22 = vault-4.${SERVICE}.${NAMESPACE}
DNS.23 = vault-4.${SERVICE}.${NAMESPACE}.svc
DNS.24 = vault-4.${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.25 = vault-5.${SERVICE}
DNS.26 = vault-5.${SERVICE}.${NAMESPACE}
DNS.27 = vault-5.${SERVICE}.${NAMESPACE}.svc
DNS.28 = vault-5.${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.29 = ${SERVICE1}
DNS.30 = ${SERVICE1}.${NAMESPACE}
DNS.31 = ${SERVICE1}.${NAMESPACE}.svc
DNS.32 = ${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.33 = vault-0.${SERVICE1}
DNS.34 = vault-0.${SERVICE1}.${NAMESPACE}
DNS.35 = vault-0.${SERVICE1}.${NAMESPACE}.svc
DNS.36 = vault-0.${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.37 = vault-1.${SERVICE1}
DNS.38 = vault-1.${SERVICE1}.${NAMESPACE}
DNS.39 = vault-1.${SERVICE1}.${NAMESPACE}.svc
DNS.40 = vault-1.${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.41 = vault-2.${SERVICE1}
DNS.42 = vault-2.${SERVICE1}.${NAMESPACE}
DNS.43 = vault-2.${SERVICE1}.${NAMESPACE}.svc
DNS.44 = vault-2.${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.45 = vault-3.${SERVICE1}
DNS.46 = vault-3.${SERVICE1}.${NAMESPACE}
DNS.47 = vault-3.${SERVICE1}.${NAMESPACE}.svc
DNS.48 = vault-3.${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.49 = vault-4.${SERVICE1}
DNS.50 = vault-4.${SERVICE1}.${NAMESPACE}
DNS.51 = vault-4.${SERVICE1}.${NAMESPACE}.svc
DNS.52 = vault-4.${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.53 = vault-5.${SERVICE1}
DNS.54 = vault-5.${SERVICE1}.${NAMESPACE}
DNS.55 = vault-5.${SERVICE1}.${NAMESPACE}.svc
DNS.56 = vault-5.${SERVICE1}.${NAMESPACE}.svc.cluster.local
DNS.57 = vault-0.${SERVICE2}
DNS.58 = vault-0.${SERVICE2}.${NAMESPACE}
DNS.59 = vault-0.${SERVICE2}.${NAMESPACE}.svc
DNS.60 = vault-0.${SERVICE2}.${NAMESPACE}.svc.cluster.local
DNS.61 = vault-1.${SERVICE2}
DNS.62 = vault-1.${SERVICE2}.${NAMESPACE}
DNS.63 = vault-1.${SERVICE2}.${NAMESPACE}.svc
DNS.64 = vault-1.${SERVICE2}.${NAMESPACE}.svc.cluster.local
DNS.65 = vault-2.${SERVICE2}
DNS.66 = vault-2.${SERVICE2}.${NAMESPACE}
DNS.67 = vault-2.${SERVICE2}.${NAMESPACE}.svc
DNS.68 = vault-2.${SERVICE2}.${NAMESPACE}.svc.cluster.local
DNS.69 = vault-3.${SERVICE2}
DNS.70 = vault-3.${SERVICE2}.${NAMESPACE}
DNS.71 = vault-3.${SERVICE2}.${NAMESPACE}.svc
DNS.72 = vault-3.${SERVICE2}.${NAMESPACE}.svc.cluster.local
DNS.73 = vault-4.${SERVICE2}
DNS.74 = vault-4.${SERVICE2}.${NAMESPACE}
DNS.75 = vault-4.${SERVICE2}.${NAMESPACE}.svc
DNS.76 = vault-4.${SERVICE2}.${NAMESPACE}.svc.cluster.local
DNS.77 = vault-5.${SERVICE2}
DNS.78 = vault-5.${SERVICE2}.${NAMESPACE}
DNS.79 = vault-5.${SERVICE2}.${NAMESPACE}.svc
DNS.80 = vault-5.${SERVICE2}.${NAMESPACE}.svc.cluster.local
DNS.81 = vault-0.${SERVICE3}
DNS.82 = vault-0.${SERVICE3}.${NAMESPACE}
DNS.83 = vault-0.${SERVICE3}.${NAMESPACE}.svc
DNS.84 = vault-0.${SERVICE3}.${NAMESPACE}.svc.cluster.local
DNS.85 = vault-1.${SERVICE3}
DNS.86 = vault-1.${SERVICE3}.${NAMESPACE}
DNS.87 = vault-1.${SERVICE3}.${NAMESPACE}.svc
DNS.88 = vault-1.${SERVICE3}.${NAMESPACE}.svc.cluster.local
DNS.89 = vault-2.${SERVICE3}
DNS.90 = vault-2.${SERVICE3}.${NAMESPACE}
DNS.91 = vault-2.${SERVICE3}.${NAMESPACE}.svc
DNS.92 = vault-2.${SERVICE3}.${NAMESPACE}.svc.cluster.local
DNS.93 = vault-3.${SERVICE3}
DNS.94 = vault-3.${SERVICE3}.${NAMESPACE}
DNS.95 = vault-3.${SERVICE3}.${NAMESPACE}.svc
DNS.96 = vault-3.${SERVICE3}.${NAMESPACE}.svc.cluster.local
DNS.97 = vault-4.${SERVICE3}
DNS.98 = vault-4.${SERVICE3}.${NAMESPACE}
DNS.99 = vault-4.${SERVICE3}.${NAMESPACE}.svc
DNS.100 = vault-4.${SERVICE3}.${NAMESPACE}.svc.cluster.local
DNS.101 = vault-5.${SERVICE3}
DNS.102 = vault-5.${SERVICE3}.${NAMESPACE}
DNS.103 = vault-5.${SERVICE3}.${NAMESPACE}.svc
DNS.104 = vault-5.${SERVICE3}.${NAMESPACE}.svc.cluster.local
DNS.105 = vault-0.${SERVICE4}
DNS.106 = vault-0.${SERVICE4}.${NAMESPACE}
DNS.107 = vault-0.${SERVICE4}.${NAMESPACE}.svc
DNS.108 = vault-0.${SERVICE4}.${NAMESPACE}.svc.cluster.local
DNS.109 = vault-1.${SERVICE4}
DNS.110 = vault-1.${SERVICE4}.${NAMESPACE}
DNS.111 = vault-1.${SERVICE4}.${NAMESPACE}.svc
DNS.112 = vault-1.${SERVICE4}.${NAMESPACE}.svc.cluster.local
DNS.113 = vault-2.${SERVICE4}
DNS.114 = vault-2.${SERVICE4}.${NAMESPACE}
DNS.115 = vault-2.${SERVICE4}.${NAMESPACE}.svc
DNS.116 = vault-2.${SERVICE4}.${NAMESPACE}.svc.cluster.local
DNS.117 = vault-3.${SERVICE4}
DNS.118 = vault-3.${SERVICE4}.${NAMESPACE}
DNS.119 = vault-3.${SERVICE4}.${NAMESPACE}.svc
DNS.120 = vault-3.${SERVICE4}.${NAMESPACE}.svc.cluster.local
DNS.121 = vault-4.${SERVICE4}
DNS.122 = vault-4.${SERVICE4}.${NAMESPACE}
DNS.123 = vault-4.${SERVICE4}.${NAMESPACE}.svc
DNS.124 = vault-4.${SERVICE4}.${NAMESPACE}.svc.cluster.local
DNS.125 = vault-5.${SERVICE4}
DNS.126 = vault-5.${SERVICE4}.${NAMESPACE}
DNS.127 = vault-5.${SERVICE4}.${NAMESPACE}.svc
DNS.128 = vault-5.${SERVICE4}.${NAMESPACE}.svc.cluster.local
IP.1 = 127.0.0.1
EOF

openssl req -new -key ${TMPDIR}/vault.key -subj "/CN=${SERVICE}.${NAMESPACE}.svc" -out ${TMPDIR}/server.csr -config ${TMPDIR}/csr.conf


export CSR_NAME=vault-csr
cat <<EOF >${TMPDIR}/csr.yaml
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${CSR_NAME}
spec:
  groups:
  - system:authenticated
  request: $(cat ${TMPDIR}/server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

kubectl create -f ${TMPDIR}/csr.yaml

kubectl certificate approve ${CSR_NAME}

serverCert=$(kubectl get csr ${CSR_NAME} -o jsonpath='{.status.certificate}')

echo "${serverCert}" | openssl base64 -d -A -out ${TMPDIR}/vault.crt
kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > ${TMPDIR}/ca.crt

kubectl create namespace ${NAMESPACE}

kubectl create secret generic ${SECRET_NAME} \
        --namespace ${NAMESPACE} \
        --from-file=server.key=${TMPDIR}/vault.key \
        --from-file=server.crt=${TMPDIR}/vault.crt \

kubectl create secret generic ${SECRET_NAME2} \
        --namespace ${NAMESPACE} \
        --from-file=ca.crt=${TMPDIR}/ca.crt \
