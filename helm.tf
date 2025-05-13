resource "helm_release" "langflow" {
  name       = var.helm_release_name
  repository = var.helm_repository
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  namespace  = "langflow"
  create_namespace = true
  timeout    = 900  # 15 minutes in seconds

  # Values in values.yaml can be set using the following format:
  values = [
    file("${path.module}/ide/values.yaml")
  ]
  set {
    name  = "image.tag"
    value = var.langflow_version
  }

  set {
    name  = "externalDatabase.enabled"
    value = "true"
  }

  set {
    name  = "externalDatabase.driver"
    value = "postgresql"
  }

  set {
    name  = "externalDatabase.host"
    value = azurerm_postgresql_flexible_server.postgres.fqdn
  }

  set {
    name  = "externalDatabase.port"
    value = "5432"
  }
  set {
    name  = "externalDatabase.database"
    value = "langflow-db-${var.environment}"
  }

  set {
    name  = "externalDatabase.user"
    value = azurerm_postgresql_flexible_server.postgres.administrator_login
  }

  set {
    name  = "externalDatabase.password"
    value = azurerm_postgresql_flexible_server.postgres.administrator_password
  }

  set {
    name  = "postgresql.enabled"
    value = "false"
  }

  set {
    name  = "sqlite.enabled"
    value = "false"
  }

  set {
    name  = "postgresql.password"
    value = azurerm_postgresql_flexible_server.postgres.administrator_password
  }
  
  
  

  set {
    name  = "environment"
    value = var.environment
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

    # Configure frontend service to use LoadBalancer
  set {
    name  = "langflow.frontend.service.type"
    value = "LoadBalancer"
  }

  # Configure backend service to use LoadBalancer
  set {
    name  = "langflow.backend.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.externalTrafficPolicy"
    value = "Cluster"
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
    name  = "service.ports[0].name"
    value = "http"
  }

  set {
    name  = "service.ports[1].port"
    value = "7680"
  }

  set {
    name  = "service.ports[1].targetPort"
    value = "7680"
  }

  set {
    name  = "service.ports[1].name"
    value = "management"
  }

  # Optional: Add Azure-specific annotations if needed
  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "false"
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