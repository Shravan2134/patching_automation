#!/bin/bash

RG_NAME="My_RG"

for vm in $(az vm list -g $RG_NAME --query "[].name" -o tsv); do
  echo "VM: $vm"


# assigning managed identity to VM's

az vm identity assign -g $RG_NAME --name $vm

# install AAD Login extgension

az vm extension set \
  --name AADLoginForLinux \
  --publisher Microsoft.Azure.ActiveDirectory.LinuxSSH \
  --version 1.0 \
  --vm-name $vm \
  --resource-group $RG_NAME 

# ensure password auth is enabled

az vm update \
    --name $vm \
    --resource-group $RG_NAME \
    --set osProfile.linuxConfiguration.disablePasswordAuthentication=false

    echo "AAD Login enabled for: $vm"
done