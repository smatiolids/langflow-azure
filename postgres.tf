resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "postgresql-langflow-${var.environment}"
  resource_group_name = azurerm_resource_group.langflow_rg.name
  location            = var.postgresql_location
  version            = "14"
  
  administrator_login    = var.postgresql_administrator_login
  administrator_password = var.postgresql_administrator_password

  storage_mb = 32768

  sku_name = "B_Standard_B1ms"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  tags = var.tags
}

# Allow all Azure services to access the PostgreSQL server
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
