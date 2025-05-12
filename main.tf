# Azure provider configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
  
  # Service Principal Authentication
  # subscription_id = var.azure_subscription_id
  # client_id       = var.azure_client_id        # App ID
  # client_secret   = var.azure_client_secret    # Password
  # tenant_id       = var.azure_tenant_id
}

# Configure Helm provider
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

# Create a resource group
resource "azurerm_resource_group" "langflow_rg" {
  name     = "langflow-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Create AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}-${var.environment}"
  location            = azurerm_resource_group.langflow_rg.location
  resource_group_name = azurerm_resource_group.langflow_rg.name
  dns_prefix         = "${var.cluster_name}-${var.environment}"
  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    
    # Enable auto-scaling (optional)
    enable_auto_scaling = false
    # min_count          = 1
    # max_count          = 3
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = var.tags
} 

