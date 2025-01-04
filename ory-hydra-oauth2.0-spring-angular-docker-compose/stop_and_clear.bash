#!/bin/bash

nginx_cert_rm(){
    rm -rf $1/nginx/cert
}

source .env
echo "------------------ STOP ALL ------------------"

echo "------------------ AUTHORIZATION SERVER ------------------"
AUTH_DIR=ory_hydra_oauth2_example_authorization_server
REMOTE_AUTH_DIR=authorization_server

echo "------------------ STOP AND CLEAR authorization server------------------"
ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "cd ${REMOTE_AUTH_DIR} && docker compose -f docker-compose.yaml -f docker-compose.prod.yaml down -v"
ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "rm -rf ${REMOTE_AUTH_DIR}"
echo "------------------------------------------------------"

echo "------------------ rm htpasswd_introspect authorization server ------------------"
rm htpasswd_introspect
echo "------------------------------------------------------"

echo "------------------ rm nginx cert authorization server------------------"
nginx_cert_rm ${AUTH_DIR}
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"


echo "------------------ RESOURCE SERVER ------------------"
RESOURCE_DIR=ory_hydra_oauth2_example_resource_server
REMOTE_RESOURCE_DIR=resource_server

echo "------------------ STOP AND CLEAR resource server------------------"
ssh ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER} "cd ${REMOTE_RESOURCE_DIR} && docker compose down -v"
ssh ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER} "rm -rf ${REMOTE_RESOURCE_DIR}"
echo "------------------------------------------------------"

echo "------------------ rm nginx cert authorization server------------------"
nginx_cert_rm ${RESOURCE_DIR}
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "------------------ CLIENT READONLY SERVER ------------------"
CLIENT_READONLY_DIR=ory_hydra_oauth2_example_client_readonly
REMOTE_CLIENT_READONLY_DIR=client_readonly

echo "------------------ STOP AND CLEAR readonly server------------------"
ssh ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY} "cd ${REMOTE_CLIENT_READONLY_DIR} && docker compose down -v"
ssh ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY} "rm -rf ${REMOTE_CLIENT_READONLY_DIR}"
echo "------------------------------------------------------"

echo "------------------ rm nginx cert readonly server------------------"
nginx_cert_rm ${CLIENT_READONLY_DIR}
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "------------------ CLIENT WRITE AND READ SERVER ------------------"
CLIENT_WRITE_AND_READ_DIR=ory_hydra_oauth2_example_client_write_and_read
REMOTE_CLIENT_WRITE_AND_READ_DIR=client_write_and_read

echo "------------------ STOP AND CLEAR write and read server------------------"
ssh ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ} "cd ${REMOTE_CLIENT_WRITE_AND_READ_DIR} && docker compose down -v"
ssh ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ} "rm -rf ${REMOTE_CLIENT_WRITE_AND_READ_DIR}"
echo "------------------------------------------------------"

echo "------------------ rm nginx cert write and read server------------------"
nginx_cert_rm ${CLIENT_WRITE_AND_READ_DIR}
echo "------------------------------------------------------"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo "------------------ rm ca_* ------------------"
rm ca_*
echo "------------------------------------------------------"