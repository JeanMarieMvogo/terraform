output "resource_group_name" {
value = azurerm_resource_group.test.name
}
output "location" {
value = azurerm_resource_group.test.location
}
output "reseau" {
value = azurerm_virtual_network.net-1.name
}
output "sreseaucidr" {
value = azurerm_subnet.vm-subnet.address_prefixes
}
output "protocol" {
value = azurerm_network_security_rule.http.protocol 
}
output "utilisateurdeconnexion" {
value = azurerm_linux_virtual_machine.VM.admin_username
}
output "ipdeconnexion" {
value = azurerm_public_ip.linux-vm-ip.ip_address
}

