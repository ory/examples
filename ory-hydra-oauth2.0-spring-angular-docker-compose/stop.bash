#!/bin/bash

source .env
echo "------------------ STOP ALL ------------------"

echo "------------------ AUTHORIZATION SERVER ------------------"
REMOTE_AUTH_DIR=authorization_server
ssh ${USER_AUTHORIZATION_SERVER}@${IP_AUTHORIZATION_SERVER} "cd ${REMOTE_AUTH_DIR} && docker compose -f docker-compose.yaml -f docker-compose.prod.yaml down"

echo "------------------ RESOURCE SERVER ------------------"
REMOTE_RESOURCE_DIR=resource_server
ssh ${USER_RESOURCE_SERVER}@${IP_RESOURCE_SERVER} "cd ${REMOTE_RESOURCE_DIR} && docker compose down"

echo "------------------ CLIENT READONLY SERVER ------------------"
REMOTE_CLIENT_READONLY_DIR=client_readonly
ssh ${USER_CLIENT_READONLY}@${IP_CLIENT_READONLY} "cd ${REMOTE_CLIENT_READONLY_DIR} && docker compose down"

echo "------------------ CLIENT WRITE AND READ SERVER ------------------"
REMOTE_CLIENT_WRITE_AND_READ_DIR=client_write_and_read
ssh ${USER_CLIENT_WRITE_AND_READ}@${IP_CLIENT_WRITE_AND_READ} "cd ${REMOTE_CLIENT_WRITE_AND_READ_DIR} && docker compose down"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"