#!/bin/sh
TMPDIR=/tmp
NAMESPACE=vault

openssl genrsa -out ${TMPDIR}/injector-ca.key 2048

openssl req \
   -x509 \
   -new \
   -nodes \
   -key ${TMPDIR}/injector-ca.key \
   -sha256 \
   -days 1825 \
   -out ${TMPDIR}/injector-ca.crt \
   -subj "/C=US/ST=CA/L=San Francisco/O=HashiCorp/CN=vault-agent-injector-svc"


openssl genrsa -out ${TMPDIR}/tls.key 2048

openssl req \
   -new \
   -key ${TMPDIR}/tls.key \
   -out ${TMPDIR}/tls.csr \
   -subj "/C=US/ST=CA/L=San Francisco/O=HashiCorp/CN=vault-agent-injector-svc"


cat <<EOF > ${TMPDIR}/csr.conf
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = vault-agent-injector-svc
DNS.2 = vault-agent-injector-svc.vault
DNS.3 = vault-agent-injector-svc.vault.svc
DNS.4 = vault-agent-injector-svc.vault.svc.cluster.local
EOF

openssl x509 \
  -req \
  -in ${TMPDIR}/tls.csr \
  -CA ${TMPDIR}/injector-ca.crt \
  -CAkey ${TMPDIR}/injector-ca.key \
  -CAcreateserial \
  -out ${TMPDIR}/tls.crt \
  -days 1825 \
  -sha256 \
  -extfile ${TMPDIR}/csr.conf

kubectl create secret generic injector-tls \
    --from-file ${TMPDIR}/tls.crt \
    --from-file ${TMPDIR}/tls.key \
    --namespace=${NAMESPACE}

export CA_BUNDLE=$(cat ${TMPDIR}/injector-ca.crt | base64)

helm install vault hashicorp/vault --namespace ${NAMESPACE} \
	--set="injector.certs.secretName=injector-tls" \
	--set="injector.certs.caBundle=${CA_BUNDLE?}" \
	-f ./override-values.yml \
        --version 0.19.0 > vault.helm
