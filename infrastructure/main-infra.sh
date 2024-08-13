#!/bin/bash

####################################################
#### Deploy complete infrastructure for the PoC ####
####################################################

# Main file for the deployment of the infrastructure. Step by step deployment with the help Azure CLI and ARM Templates

# Variables
RESOURCE_GROUP="passwordless-transition-poc-deployment"
LOCATION="EastUS"
TEMPLATE_DIR="./arm-templates"

###############################
#### Deploy resource group ####
###############################

az deployment sub create --location $LOCATION --template-file $TEMPLATE_DIR/resource-group/template.json --parameters @$TEMPLATE_DIR/resource-group/parameters.json

##########################
#### Deploy SQL infra ####
##########################

# Pre process the file to generate parameters-final.json with correct secrets, create a personal config.json file
chmod +x $TEMPLATE_DIR/sql-infra/parser.sh
cd $TEMPLATE_DIR/sql-infra || exit
$TEMPLATE_DIR/sql-infra/parser.sh

cd ../..
az deployment group create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_DIR/sql-infra/template.json --parameters @$TEMPLATE_DIR/sql-infra/parameters-final.json

###################
#### Deploy VM ####
###################

# modify adminPassword in parameters.json
az deployment group create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_DIR/vm-and-network/template.json --parameters @$TEMPLATE_DIR/vm-and-network/parameters.json

###########################
#### Deploy Logic Apps ####
###########################

# First logic app - fromUncommittedToStaged
# Insert correct subscription <@sub_id>
az deployment group create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_DIR/logic-apps/la-01/template.json --parameters @$TEMPLATE_DIR/logic-apps/la-01/parameters.json

# Second logic app - TAPissuer
# Insert correct subscription <@sub_id>
az deployment group create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_DIR/logic-apps/la-02/template.json --parameters @$TEMPLATE_DIR/logic-apps/la-02/parameters.json

# Third logic app - fromStagedToCommitted
# Insert correct subscription <@sub_id>
az deployment group create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE_DIR/logic-apps/la-03/template.json --parameters @$TEMPLATE_DIR/logic-apps/la-03/parameters.json
