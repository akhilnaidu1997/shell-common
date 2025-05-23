output "output12" {
  description = "Resource group name"
  value       = azurerm_resource_group.RG-01.name

}

output "virtual_net" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.Vnet-01.name

}

output "subnet-01" {
  description = "Subnet Name"
  value       = azurerm_subnet.subnet-01.name

}