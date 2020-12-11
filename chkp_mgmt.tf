# Create virtual machine
resource "azurerm_virtual_machine" "chkpmgmt" {
  name                         = "r80dot40mgmt"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  network_interface_ids        = [azurerm_network_interface.mgmtexternal.id]
  primary_network_interface_id = azurerm_network_interface.mgmtexternal.id
  vm_size                      = var.management_server_size

  storage_os_disk {
    name              = "R80dot40OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "checkpoint"
    offer     = "check-point-cg-r8040"
    sku       = "mgmt-byol"
    version   = "latest"
  }

  plan {
    name      = "mgmt-byol"
    publisher = "checkpoint"
    product   = "check-point-cg-r8040"
  }
  os_profile {
    computer_name  = "r80dot40mgmt"
    admin_username = "azureuser"
    admin_password = "Cpwins1!"
    custom_data    = var.my_custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  
    ssh_keys {
      path = "/home/notused/.ssh/authorized_keys"
      key_data = file("${path.module}/azure_public_key")
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}

