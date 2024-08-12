#!/bin/bash

# Variables
RESOURCE_GROUP="passwordless-transition-poc-deployment"
LOCATION="EastUS"
TEMPLATE_DIR="./arm-templates"

# Deploy resource group from template
az deployment sub create --location $LOCATION --template-file $TEMPLATE_DIR/resource-group/template.json --parameters @$TEMPLATE_DIR/resource-group/parameters.json

# Deploy SQL infrastructure

## Pre process the file to generate parameters-final.json with correct secrets
chmod +x $TEMPLATE_DIR/sql-infra/parser.sh
cd $TEMPLATE_DIR/sql-infra || exit
$TEMPLATE_DIR/sql-infra/parser.sh

cd ../..
az deployment group create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_DIR/sql-infra/template.json --parameters @$TEMPLATE_DIR/sql-infra/parameters-final.json
