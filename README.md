# Containerized App on Azure with Terraform

This project provisions a containerized application infrastructure on Azure using Terraform, following cloud best practices and modular design.

## Architecture Overview

The infrastructure includes:

- **Networking**: Virtual Network with public and private subnets, NAT Gateway for outbound traffic
- **Load Balancing**: Application Gateway with public IP, HTTP listener, and health probes
- **Compute**: Azure Container Apps environment with containerized application
- **Observability**: Log Analytics Workspace with diagnostic logs for all resources

## Directory Structure

```
terraform-azure-container-app/
├── main.tf                 # Root module that ties everything together
├── variables.tf            # Variables for the root module
├── terraform.tfvars        # Default variable values
├── modules/
│   ├── networking/         # VNet, subnets, NAT Gateway
│   ├── app/                # Application Gateway
│   ├── container_app/      # Container Apps environment
│   └── logging/            # Log Analytics Workspace
└── README.md              # This file
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions

## Remote State Configuration (Azure Storage)

This project replaces the AWS S3 + DynamoDB pattern with Azure Storage:
- Azure Storage Account acts as the state storage (equivalent to S3)
- Azure Storage provides built-in locking/leasing capabilities (equivalent to DynamoDB)
- To enable, uncomment the backend configuration in `main.tf` and provide actual values

## Deployment Steps

1. **Login to Azure**:
   ```bash
   az login
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the execution plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

5. **Destroy resources (when needed)**:
   ```bash
   terraform destroy
   ```

## Variables

Customize your deployment by modifying `terraform.tfvars` or passing variables directly:

- `resource_group_name`: Name of the resource group (default: "container-app-rg")
- `location`: Azure region (default: "East US")
- `container_image`: Container image to deploy (default: "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest")
- `container_cpu`: CPU units for the container (default: 0.25)
- `container_memory`: Memory for the container (default: "0.5Gi")
- `tags`: Resource tags (default: {project = "static-website"})

## Application Access

After deployment, your application will be accessible via the Application Gateway's public IP. The health endpoint is configured at `/health` on port 8080.

## Security Considerations

- The Container App runs in private subnets with no direct external access
- Application Gateway serves as the ingress point
- Network Security Groups can be added for additional security (not included in this example)
- Diagnostic logging is enabled for monitoring and troubleshooting