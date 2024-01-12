#!/bin/bash

generate_CA() {
    
    if [ ! -f $1.crt ];
    then
        # generating a key for a CA
        # генерация ключа для CA
        openssl genrsa -out $1.key 4096
        
        # generating a certificate for a CA
        # формирование сертификата для CA
        openssl req -x509 -new -nodes -sha512 -days 999999 \
        -subj "/C=RU/ST=Stavropol region/L=Stavropol/O=Some ORG/OU=Some dep/CN=some cn gateway nginx for $1" \
        -key $1.key \
        -out $1.crt
    else
        echo "CA gateway nginx for $1 is exists"
    fi
}


generate_cert(){
    
if [ ! -f $1/nginx/cert/${2}/${2}.crt ]; then

    mkdir -p $1/nginx/cert/${2}

    # private key
    # закрытый ключ
    openssl genrsa -out $1/nginx/cert/${2}/${2}.key 4096

    # Request for Certification (CSR)
    # запрос на сертификацию (CSR)
    openssl req -sha512 -new \
        -subj "/C=RU/ST=Stavropol region/L=Stavropol/O=Some ORG/OU=Some dep/CN=${2}" \
        -key $1/nginx/cert/${2}/${2}.key \
        -out ${2}.csr


    # v3 extension for the certificate
    # расширение v3 для сертификата
    cat >v3-${2}.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=${2}
EOF
    # certificate generation
    # генерация сертификата
    openssl x509 -req -sha512 -days 999999 \
        -extfile v3-${2}.ext \
        -CA $3.crt -CAkey $3.key -CAcreateserial \
        -in ${2}.csr \
        -out $1/nginx/cert/${2}/${2}.crt

    rm -rf ${2}.csr
    rm v3-${2}.ext
    
    else
        echo "$1/nginx/cert/${2}/${2}.crt is exists"
    fi

}

source .env

echo "------------------ AUTHORIZATION SERVER ------------------"

CA_AUTH_SERVER_NAME=ca_authorization_server
AUTH_DIR=ory_hydra_oauth2_example_authorization_server
REMOTE_AUTH_DIR=authorization_server

echo "------------------ generate .env (docker compose) for authorization server ------------------"

HYDRA_DEPENDS_ON_MIGRATE="service_completed_successfully"

echo HYDRA_DEPENDS_ON_MIGRATE=${HYDRA_DEPENDS_ON_MIGRATE} >>.env_auth_server
echo USER_DATA_POSTGRESQL_PASSWORD=${USER_DATA_POSTGRESQL_PASSWORD} >>.env_auth_server
echo HYDRA_POSTGRESQL_PASSWORD=${HYDRA_POSTGRESQL_PASSWORD} >>.env_auth_server
echo HYDRA_SECRETS_COOKIE=${HYDRA_SECRETS_COOKIE} >>.env_auth_server
echo HYDRA_SECRETS_SYSTEM=${HYDRA_SECRETS_SYSTEM} >>.env_auth_server

echo "------------------------------------------------------"

echo "------------------ generate login and password introspect for authorization server ------------------"
htpasswd -bcB -C 10 htpasswd_introspect ${HYDRA_INTROSPECT_USER} ${HYDRA_INTROSPECT_PASSWORD}
mv htpasswd_introspect ${AUTH_DIR}/nginx/confs/htpasswd_introspect
echo "------------------------------------------------------"

echo "------------------ generate CA gateway nginx for authorization server ------------------"
generate_CA "${CA_AUTH_SERVER_NAME}" 
echo "------------------------------------------------------"

echo "------------------ generate certs gateway nginx for authorization server ------------------"
generate_cert "${AUTH_DIR}" "${DNS_AUTHORIZATION_SERVER}" "${CA_AUTH_SERVER_NAME}"
echo "------------------------------------------------------"

echo "------------------ create folder for authorization server------------------"
ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "mkdir ${REMOTE_AUTH_DIR}"
echo "------------------------------------------------------"

echo "------------------ remote copy .env for authorization server------------------"
scp .env_auth_server ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER}:${REMOTE_AUTH_DIR}/.env
rm .env_auth_server
echo "------------------------------------------------------"

echo "------------------ remote copy hydra for authorization server------------------"
scp -r ${AUTH_DIR}/hydra ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER}:${REMOTE_AUTH_DIR}/hydra
echo "------------------------------------------------------"

echo "------------------ remote copy nginx for authorization server------------------"
DNS_AUTHORIZATION_SERVER=${DNS_AUTHORIZATION_SERVER} envsubst '$DNS_AUTHORIZATION_SERVER' < ${AUTH_DIR}/nginx/confs/authorization-server.conf.templ > ${AUTH_DIR}/nginx/confs/authorization-server.conf
scp -r ${AUTH_DIR}/nginx ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER}:${REMOTE_AUTH_DIR}/nginx
rm ${AUTH_DIR}/nginx/confs/authorization-server.conf
rm ${AUTH_DIR}/nginx/confs/htpasswd_introspect
echo "------------------------------------------------------"

echo "------------------ remote copy user_data for authorization server------------------"
scp -r ${AUTH_DIR}/user_data ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER}:${REMOTE_AUTH_DIR}/user_data
echo "------------------------------------------------------"

echo "------------------ remote copy docker-compose.yaml for authorization server------------------"
scp ${AUTH_DIR}/docker-compose.yaml ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER}:${REMOTE_AUTH_DIR}/docker-compose.yaml
scp ${AUTH_DIR}/docker-compose.prod.yaml ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER}:${REMOTE_AUTH_DIR}/docker-compose.prod.yaml
echo "------------------------------------------------------"

echo "------------------ START authorization server------------------"
ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "cd ${REMOTE_AUTH_DIR} && docker compose -f docker-compose.yaml -f docker-compose.prod.yaml up -d --no-recreate --wait"
echo "------------------------------------------------------"

echo "------------------ Create OAuth 2.0 client for only read------------------"

code_client_readonly=$(ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "cd authorization_server && docker compose -f docker-compose.yaml -f docker-compose.prod.yaml exec ory-hydra-oauth2-example-authorization-server-hydra \
    hydra create client \
    --endpoint http://127.0.0.1:4445 \
    --grant-type authorization_code,refresh_token \
    --response-type code,id_token \
    --format json \
    --scope openid --scope offline --scope read \
    --redirect-uri https://${DNS_CLIENT_READONLY}/api/login/oauth2/code/client-readonly")

CLIENT_READONLY_CLIENT_ID=$(echo $code_client_readonly | jq -r '.client_id')
CLIENT_READONLY_CLIENT_SECRET=$(echo $code_client_readonly | jq -r '.client_secret')

echo "------------------------------------------------------"
echo "------------------ Create OAuth 2.0 client for read and write ------------------"
    
code_client_read_and_write=$(ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "cd authorization_server && docker compose -f docker-compose.yaml -f docker-compose.prod.yaml exec ory-hydra-oauth2-example-authorization-server-hydra \
    hydra create client \
    --endpoint http://127.0.0.1:4445 \
    --grant-type authorization_code,refresh_token \
    --response-type code,id_token \
    --format json \
    --scope openid --scope offline --scope read --scope write \
    --redirect-uri https://${DNS_CLIENT_WRITE_AND_READ}/api/login/oauth2/code/client-write-and-read")

CLIENT_WRITE_AND_READ_CLIENT_ID=$(echo $code_client_read_and_write | jq -r '.client_id')
CLIENT_WRITE_AND_READ_CLIENT_SECRET=$(echo $code_client_read_and_write | jq -r '.client_secret')
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "------------------ RESOURCE SERVER ------------------"

CA_RESOURCE_SERVER_NAME="ca_resource_server"
RESOURCE_DIR=ory_hydra_oauth2_example_resource_server
REMOTE_RESOURCE_DIR=resource_server

echo "------------------ create folder for resource server------------------"
ssh ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER} "mkdir ${REMOTE_RESOURCE_DIR}"
echo "------------------------------------------------------"

echo "------------------ remote copy ca-certificates for resource server ------------------"
cp ${CA_AUTH_SERVER_NAME}.crt ${RESOURCE_DIR}/ca-certificates/
scp -r ${RESOURCE_DIR}/ca-certificates ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER}:${REMOTE_RESOURCE_DIR}/ca-certificates
rm ${RESOURCE_DIR}/ca-certificates/${CA_AUTH_SERVER_NAME}.crt
echo "------------------------------------------------------"

echo "------------------ generate .env (docker compose) for resource server ------------------"

echo IP_AUTHORIZATION_SERVER=${IP_AUTHORIZATION_SERVER} >> .env_resource_server
echo DNS_AUTHORIZATION_SERVER=${DNS_AUTHORIZATION_SERVER} >> .env_resource_server
echo HYDRA_INTROSPECT_USER=${HYDRA_INTROSPECT_USER} >>.env_resource_server
echo HYDRA_INTROSPECT_PASSWORD=${HYDRA_INTROSPECT_PASSWORD} >>.env_resource_server

echo "------------------------------------------------------"
echo "------------------ generate CA gateway nginx for resource server ------------------"
generate_CA "${CA_RESOURCE_SERVER_NAME}" 
echo "------------------------------------------------------"

echo "------------------ generate certs gateway nginx for resource server ------------------"
generate_cert "${RESOURCE_DIR}" "${DNS_RESOURCE_SERVER}" "${CA_RESOURCE_SERVER_NAME}"
echo "------------------------------------------------------"

echo "------------------ remote copy .env for resource server------------------"
scp .env_resource_server ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER}:${REMOTE_RESOURCE_DIR}/.env
rm .env_resource_server
echo "------------------------------------------------------"

echo "------------------ remote copy nginx for resource server------------------"
DNS_RESOURCE_SERVER=${DNS_RESOURCE_SERVER} envsubst '$DNS_RESOURCE_SERVER' < ${RESOURCE_DIR}/nginx/confs/resource-server.conf.templ > ${RESOURCE_DIR}/nginx/confs/resource-server.conf
scp -r ${RESOURCE_DIR}/nginx ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER}:${REMOTE_RESOURCE_DIR}/nginx
rm ${RESOURCE_DIR}/nginx/confs/resource-server.conf
echo "------------------------------------------------------"

echo "------------------ remote copy docker-compose.yaml for resource server------------------"
scp ${RESOURCE_DIR}/docker-compose.yaml ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER}:${REMOTE_RESOURCE_DIR}/docker-compose.yaml
echo "------------------------------------------------------"

echo "------------------ START resource server------------------"
ssh ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER} "cd ${REMOTE_RESOURCE_DIR} && docker compose up -d --no-recreate --wait"
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "------------------ CLIENT READONLY SERVER ------------------"

CA_CLIENT_READONLY_SERVER_NAME="ca_client_readonly_server"
CLIENT_READONLY_DIR=ory_hydra_oauth2_example_client_readonly
REMOTE_CLIENT_READONLY_DIR=client_readonly

echo "------------------ create folder for client readonly server------------------"
ssh ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY} "mkdir ${REMOTE_CLIENT_READONLY_DIR}"
echo "------------------------------------------------------"

echo "------------------ remote copy ca-certificates for client readonly server ------------------"
cp ${CA_AUTH_SERVER_NAME}.crt ${CLIENT_READONLY_DIR}/ca-certificates/
cp ${CA_RESOURCE_SERVER_NAME}.crt ${CLIENT_READONLY_DIR}/ca-certificates/
scp -r ${CLIENT_READONLY_DIR}/ca-certificates ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY}:${REMOTE_CLIENT_READONLY_DIR}/ca-certificates
rm ${CLIENT_READONLY_DIR}/ca-certificates/${CA_AUTH_SERVER_NAME}.crt
rm ${CLIENT_READONLY_DIR}/ca-certificates/${CA_RESOURCE_SERVER_NAME}.crt
echo "------------------------------------------------------"

echo "------------------ generate .env (docker compose) for client readonly server ------------------"

echo IP_AUTHORIZATION_SERVER=${IP_AUTHORIZATION_SERVER} >> .env_readonly
echo IP_RESOURCE_SERVER=${IP_RESOURCE_SERVER} >> .env_readonly
echo DNS_AUTHORIZATION_SERVER=${DNS_AUTHORIZATION_SERVER} >> .env_readonly
echo DNS_RESOURCE_SERVER=${DNS_RESOURCE_SERVER} >> .env_readonly
echo CLIENT_READONLY_CLIENT_ID=${CLIENT_READONLY_CLIENT_ID} >>.env_readonly
echo CLIENT_READONLY_CLIENT_SECRET=${CLIENT_READONLY_CLIENT_SECRET} >>.env_readonly
echo DNS_CLIENT_READONLY=${DNS_CLIENT_READONLY} >>.env_readonly

echo "------------------------------------------------------"
echo "------------------ generate CA gateway nginx for client readonly server ------------------"
generate_CA "${CA_CLIENT_READONLY_SERVER_NAME}" 
echo "------------------------------------------------------"

echo "------------------ generate certs gateway nginx for client readonly server ------------------"
generate_cert "${CLIENT_READONLY_DIR}" "${DNS_CLIENT_READONLY}" "${CA_CLIENT_READONLY_SERVER_NAME}"
echo "------------------------------------------------------"

echo "------------------ remote copy .env for client readonly server------------------"
scp .env_readonly ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY}:${REMOTE_CLIENT_READONLY_DIR}/.env
rm .env_readonly
echo "------------------------------------------------------"

echo "------------------ remote copy nginx for client readonly server------------------"
DNS_CLIENT_READONLY=${DNS_CLIENT_READONLY} envsubst '$DNS_CLIENT_READONLY' < ${CLIENT_READONLY_DIR}/nginx/confs/client-readonly.conf.templ > ${CLIENT_READONLY_DIR}/nginx/confs/client-readonly.conf
scp -r ${CLIENT_READONLY_DIR}/nginx ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY}:${REMOTE_CLIENT_READONLY_DIR}/nginx
rm ${CLIENT_READONLY_DIR}/nginx/confs/client-readonly.conf
echo "------------------------------------------------------"

echo "------------------ remote copy docker-compose.yaml for client readonly server------------------"
scp ${CLIENT_READONLY_DIR}/docker-compose.yaml ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY}:${REMOTE_CLIENT_READONLY_DIR}/docker-compose.yaml
echo "------------------------------------------------------"

echo "------------------ START client readonly server------------------"
ssh ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY} "cd ${REMOTE_CLIENT_READONLY_DIR} && docker compose up -d --no-recreate --wait"
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "------------------ CLIENT WRITE AND READ SERVER ------------------"

CA_CLIENT_WRITE_AND_READ_SERVER_NAME="ca_client_write_and_client_server"
CLIENT_WRITE_AND_READ_DIR=ory_hydra_oauth2_example_client_write_and_read
REMOTE_CLIENT_WRITE_AND_READ_DIR=client_write_and_read

echo "------------------ create folder for client write and read server------------------"
ssh ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ} "mkdir ${REMOTE_CLIENT_WRITE_AND_READ_DIR}"
echo "------------------------------------------------------"

echo "------------------ remote copy ca-certificates for client write and read server ------------------"
cp ${CA_AUTH_SERVER_NAME}.crt ${CLIENT_WRITE_AND_READ_DIR}/ca-certificates/
cp ${CA_RESOURCE_SERVER_NAME}.crt ${CLIENT_WRITE_AND_READ_DIR}/ca-certificates/
scp -r ${CLIENT_WRITE_AND_READ_DIR}/ca-certificates ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ}:${REMOTE_CLIENT_WRITE_AND_READ_DIR}/ca-certificates
rm ${CLIENT_WRITE_AND_READ_DIR}/ca-certificates/${CA_AUTH_SERVER_NAME}.crt
rm ${CLIENT_WRITE_AND_READ_DIR}/ca-certificates/${CA_RESOURCE_SERVER_NAME}.crt
echo "------------------------------------------------------"

echo "------------------ generate .env (docker compose) for client write and read server ------------------"

echo IP_AUTHORIZATION_SERVER=${IP_AUTHORIZATION_SERVER} >> .env_write_and_read
echo IP_RESOURCE_SERVER=${IP_RESOURCE_SERVER} >> .env_write_and_read
echo DNS_AUTHORIZATION_SERVER=${DNS_AUTHORIZATION_SERVER} >> .env_write_and_read
echo DNS_RESOURCE_SERVER=${DNS_RESOURCE_SERVER} >> .env_write_and_read
echo CLIENT_WRITE_AND_READ_CLIENT_ID=${CLIENT_WRITE_AND_READ_CLIENT_ID} >>.env_write_and_read
echo CLIENT_WRITE_AND_READ_CLIENT_SECRET=${CLIENT_WRITE_AND_READ_CLIENT_SECRET} >>.env_write_and_read
echo DNS_CLIENT_WRITE_AND_READ=${DNS_CLIENT_WRITE_AND_READ} >>.env_write_and_read

echo "------------------------------------------------------"
echo "------------------ generate CA gateway nginx for client write and read server ------------------"
generate_CA "${CA_CLIENT_WRITE_AND_READ_SERVER_NAME}" 
echo "------------------------------------------------------"

echo "------------------ generate certs gateway nginx for client write and read server ------------------"
generate_cert "${CLIENT_WRITE_AND_READ_DIR}" "${DNS_CLIENT_WRITE_AND_READ}" "${CA_CLIENT_WRITE_AND_READ_SERVER_NAME}"
echo "------------------------------------------------------"

echo "------------------ remote copy .env for client write and read server------------------"
scp .env_write_and_read ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ}:${REMOTE_CLIENT_WRITE_AND_READ_DIR}/.env
rm .env_write_and_read
echo "------------------------------------------------------"

echo "------------------ remote copy nginx for client write and read server------------------"
DNS_CLIENT_WRITE_AND_READ=${DNS_CLIENT_WRITE_AND_READ} envsubst '$DNS_CLIENT_WRITE_AND_READ' < ${CLIENT_WRITE_AND_READ_DIR}/nginx/confs/client-write-and-read.conf.templ > ${CLIENT_WRITE_AND_READ_DIR}/nginx/confs/client-write-and-read.conf
scp -r ${CLIENT_WRITE_AND_READ_DIR}/nginx ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ}:${REMOTE_CLIENT_WRITE_AND_READ_DIR}/nginx
rm ${CLIENT_WRITE_AND_READ_DIR}/nginx/confs/client-write-and-read.conf
echo "------------------------------------------------------"

echo "------------------ remote copy docker-compose.yaml for client write and read server------------------"
scp ${CLIENT_WRITE_AND_READ_DIR}/docker-compose.yaml ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ}:${REMOTE_CLIENT_WRITE_AND_READ_DIR}/docker-compose.yaml
echo "------------------------------------------------------"

echo "------------------ START write and read server------------------"
ssh ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ} "cd ${REMOTE_CLIENT_WRITE_AND_READ_DIR} && docker compose up -d --no-recreate --wait"
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"