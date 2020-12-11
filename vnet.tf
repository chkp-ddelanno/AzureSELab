resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-Management"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.95.0.0/20"]
  location            = var.region
}

