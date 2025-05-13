output "resource_group_id" {
  value       = azurerm_resource_group.langflow_rg.id
  description = "The ID of the resource group"
}

output "resource_group_name" {
  value       = azurerm_resource_group.langflow_rg.name
  description = "The name of the resource group"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "The name of the AKS cluster"
}

output "aks_cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "The ID of the AKS cluster"
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  description = "Raw kubeconfig for the AKS cluster"
  sensitive   = true
}

output "cluster_fqdn" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "The FQDN of the AKS cluster"
}

output "helm_release_status" {
  value       = helm_release.langflow.status
  description = "Status of the Helm release"
}

output "helm_release_namespace" {
  value       = helm_release.langflow.namespace
  description = "Namespace of the Helm release"
} 
