
# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "langflow-${var.environment}-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.langflow_rg.location
  resource_group_name = azurerm_resource_group.langflow_rg.name
  tags                = var.tags
}

# Create a subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.langflow_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

# Create a Network Security Group
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "langflow-${var.environment}-nsg"
  location            = azurerm_resource_group.langflow_rg.location
  resource_group_name = azurerm_resource_group.langflow_rg.name

  # Allow HTTP traffic (8080)
  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow backend traffic (7680)
  security_rule {
    name                       = "allow-backend"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "7680"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow backend API traffic (7860)
  security_rule {
    name                       = "allow-api"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "7860"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate the NSG with the AKS subnet
resource "azurerm_subnet_network_security_group_association" "aks_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}