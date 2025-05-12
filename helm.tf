resource "helm_release" "langflow" {
  name       = var.helm_release_name
  repository = var.helm_repository
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  namespace  = "langflow"
  create_namespace = true

  # Values in values.yaml can be set using the following format:
  set {
    name  = "image.tag"
    value = var.langflow_version
  }

  set {
    name  = "environment"
    value = var.environment
  }

  set {
    name  = "service.ports[0].port"
    value = "8080"
  }

  set {
    name  = "service.ports[0].targetPort"
    value = "8080"
  }

  set {
    name  = "service.ports[1].port"
    value = "7680"
  }

  set {
    name  = "service.ports[1].targetPort"
    value = "7680"
  }

  # For sensitive values, use set_sensitive
  # set_sensitive {
  #   name  = "secrets.apiKey"
  #   value = var.api_key
  # }

  # You can also specify values using a values file
  # values = [
  #   file("${path.module}/values.yaml")
  # ]

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
} 
