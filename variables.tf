variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {
    "environment" = "dev",
    "project"     = "langflow"
  }
} 

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "eastus"
}

# variable "azure_subscription_id" {
#   type        = string
#   sensitive   = true
#   description = "Azure subscription id"
# }

# variable "azure_client_id" {
#   type        = string
#   sensitive   = true
#   description = "Azure client id"
# }

# variable "azure_client_secret" {
#   type        = string
#   sensitive   = true
#   description = "Azure client secret"
# }

# variable "azure_tenant_id" {
#   type        = string
#   sensitive   = true
#   description = "Azure tenant id"
# }

variable "langflow_version" {
  type        = string
  description = "Langflow version"
  default     = "1.4.0"
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "langflow-aks"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.31.1"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 2
}

variable "node_vm_size" {
  type        = string
  description = "VM size for nodes"
  default     = "Standard_D2s_v3"
}

variable "helm_release_name" {
  type        = string
  description = "Name of the Helm release"
  default     = "langflow"
}

variable "helm_chart_version" {
  type        = string
  description = "Version of the Helm chart"
  default     = "0.1.0"
}

variable "helm_repository" {
  type        = string
  description = "Helm chart repository URL"
  default     = "https://langflow-ai.github.io/langflow-helm-charts"  # Update this with your actual helm repo
}

variable "helm_chart_name" {
  type        = string
  description = "Name of the Helm chart"
  default     = "langflow-ide"
}

