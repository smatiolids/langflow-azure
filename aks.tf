
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

# Create namespace
resource "kubernetes_namespace" "langflow_namespace" {
  metadata {
    name = "langflow"
  }
  
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

# Create Storage Class for Langflow
resource "kubernetes_storage_class" "langflow_storage" {
  metadata {
    name = "langflow-storage"
  }
  storage_provisioner = "kubernetes.io/azure-disk"
  reclaim_policy      = "Retain"
  parameters = {
    storageaccounttype = "Premium_LRS"
    kind               = "Managed"
  }
  mount_options = ["file_mode=0777", "dir_mode=0777", "uid=1000", "gid=1000"]
  
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    kubernetes_namespace.langflow_namespace
  ]
}


# Update the Helm values to use our custom storage class
resource "kubernetes_config_map" "langflow_storage_config" {
  metadata {
    name      = "langflow-storage-config"
    namespace = "langflow"
  }

  data = {
    "storage-class" = kubernetes_storage_class.langflow_storage.metadata[0].name
  }

  depends_on = [
    kubernetes_namespace.langflow_namespace,
    kubernetes_storage_class.langflow_storage
  ]
}