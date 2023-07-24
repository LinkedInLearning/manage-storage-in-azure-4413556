#/bin/bash

LOCATION='westus'
RESOURCE_GROUP_NAME='rg-03-04'
STORAGE_ACCOUNT_NAME='sa0304azcliscript'

az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku 'Standard_RAGRS' \
  --kind 'StorageV2' \
  --min-tls-version 'TLS1_2' \
  --public-network-access 'Disabled'
  