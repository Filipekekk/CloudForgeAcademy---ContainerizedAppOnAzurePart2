# Backend Configuration Example
# To use remote state with Azure Storage, create a backend.hcl file with your actual values:

# resource_group_name  = "your-terraform-state-rg"
# storage_account_name = "yourstorageaccountname"
# container_name       = "tfstate"
# key                  = "container-apps.terraform.tfstate"

# Then initialize with:
# terraform init -backend-config=backend.hcl