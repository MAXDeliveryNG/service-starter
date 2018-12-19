#!/bin/bash
# Deployment script

# Target environment
target_env=${DEPLOY_TARGET}

# Azure service principal variables
sp_user=${AZURE_SP_USER}
sp_pass=${AZURE_SP_USER_PASS}
sp_tenant=${AZURE_SP_TENANT}

# Azure AKS variables
if [[ ((`echo $target_env | grep -c "production"` > 0)) ]]; then
    az_aks_rg='maxv3-production'
    az_aks_name='maxv3-production'
fi

if [[ ((`echo $target_env | grep -c "staging"` > 0)) ]]; then
    az_aks_rg='maxv3-staging'
    az_aks_name='milkyway'
fi

# Azure Login
az login --service-principal -u $sp_user -p $sp_pass --tenant $sp_tenant

# install kubectl
sudo chmod 777 /usr/local/bin
az aks install-cli --debug

# Connect cluster
echo connecting to $target_env cluster
az aks get-credentials --resource-group $az_aks_rg --name $az_aks_name

# Init helm
helm init --client-only

# Add helm repo
helm repo add MAXDeliveryNG https://maxdeliveryng.github.io/helm-charts
helm repo update

if [[ ((`echo $target_env | grep -c "production"` > 0)) ]] 
then
    values='production.yaml'
elif [[ ((`echo $target_env | grep -c "staging"` > 0)) ]]
then
    values='staging.yaml'
fi

# Replace with service name
if [[ ((`helm list | grep -c "service-name"` > 0)) ]]
then
    helm upgrade service-name MAXDeliveryNG/service-name --debug --recreate-pods --namespace default -f helm/$values
else
    helm install MAXDeliveryNG/service-name --debug -n service-name --namespace default -f helm/$values
fi