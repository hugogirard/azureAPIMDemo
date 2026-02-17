#!/bin/bash

# Azure API Management Deployment Script
# This script deploys the main.bicep file with parameters from main.bicepparam
# and prompts for the publisherEmail to overwrite the parameter file value

set -e

# Change to the script's directory
cd "$(dirname "$0")"

# Prompt for Publisher Email
echo "======================================"
echo "Azure APIM Deployment"
echo "======================================"
echo ""
read -p "Enter Publisher Email (required): " PUBLISHER_EMAIL

# Validate email input
if [ -z "$PUBLISHER_EMAIL" ]; then
    echo "Error: Publisher Email is required"
    exit 1
fi

# Extract location from the bicepparam file
LOCATION=$(grep "param location" infra/main.bicepparam | sed "s/.*= '\(.*\)'/\1/")

if [ -z "$LOCATION" ]; then
    echo "Error: Could not read location from parameters file"
    exit 1
fi

echo ""
echo "Starting deployment..."
echo "Parameters file: infra/main.bicepparam"
echo "Location: $LOCATION"
echo "Publisher Email: $PUBLISHER_EMAIL"
echo ""

# Deploy the Bicep template at subscription scope
az deployment sub create \
  --name "apim-deployment-$(date +%Y%m%d-%H%M%S)" \
  --location "$LOCATION" \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam \
  --parameters publisherEmail="$PUBLISHER_EMAIL"

echo ""
echo "Deployment completed successfully!"
