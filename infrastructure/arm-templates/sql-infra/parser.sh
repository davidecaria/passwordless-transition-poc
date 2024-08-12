#!/bin/bash

# Load config values
CONFIG_FILE="./config.json"
SUBSCRIPTION_ID=$(jq -r '.subscriptionId' $CONFIG_FILE)
CLIENT_IP=$(jq -r '.clientIpValue' $CONFIG_FILE)
PE_DNS_RECORD_ID=$(jq -r '.privateEndpointDnsRecordUniqueId' $CONFIG_FILE)
PE_NESTED_TEMPLATE_ID=$(jq -r '.privateEndpointNestedTemplateId' $CONFIG_FILE)
ADMIN_LOGIN=$(jq -r '.adminLogin' $CONFIG_FILE)
ADMIN_SID=$(jq -r '.adminSID' $CONFIG_FILE)
TENANT_ID=$(jq -r '.tenantId' $CONFIG_FILE)
ADMIN_PASSWORD=$(jq -r '.administratorLoginPassword' $CONFIG_FILE)

# Replace placeholders in parameters.json
sed -e "s|\[config('subscriptionId')\]|$SUBSCRIPTION_ID|g" \
    -e "s|\[config('clientIpValue')\]|$CLIENT_IP|g" \
    -e "s|\[config('privateEndpointDnsRecordUniqueId')\]|$PE_DNS_RECORD_ID|g" \
    -e "s|\[config('privateEndpointNestedTemplateId')\]|$PE_NESTED_TEMPLATE_ID|g" \
    -e "s|\[config('adminLogin')\]|$ADMIN_LOGIN|g" \
    -e "s|\[config('adminSID')\]|$ADMIN_SID|g" \
    -e "s|\[config('tenantId')\]|$TENANT_ID|g" \
    -e "s|\[config('administratorLoginPassword')\]|$ADMIN_PASSWORD|g" \
    ./parameters.json > ./parameters-final.json
