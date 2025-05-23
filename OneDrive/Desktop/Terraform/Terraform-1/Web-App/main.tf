terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }

}
provider "azurerm" {
  features {

  }
  subscription_id = "4699444d-9dbe-4577-bcf3-e6f87b89ec7a"

}

resource "azurerm_resource_group" "RG-01" {
  name     = var.azureRG
  location = "eastus"
}

resource "azurerm_virtual_network" "Vnet-01" {
  name                = "Vnet-01"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.RG-01.name
  location            = azurerm_resource_group.RG-01.location

}

resource "azurerm_subnet" "subnet-01" {
  name                 = "Subnet-01"
  resource_group_name  = azurerm_resource_group.RG-01.name
  virtual_network_name = azurerm_virtual_network.Vnet-01.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_public_ip" "Pub-ip" {
  name                = "public-IP"
  location            = azurerm_resource_group.RG-01.location
  resource_group_name = azurerm_resource_group.RG-01.name
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "nic" {
  name                = "NIC-01"
  location            = azurerm_resource_group.RG-01.location
  resource_group_name = azurerm_resource_group.RG-01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Pub-ip.id
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "Linux-Vm-01"
  resource_group_name = azurerm_resource_group.RG-01.name
  location            = azurerm_resource_group.RG-01.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}

resource "azurerm_network_security_group" "nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.RG-01.location
  resource_group_name = azurerm_resource_group.RG-01.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
