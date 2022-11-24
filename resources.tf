resource "azurerm_resource_group" "test" {
   name     = var.environment
   location = var.location
}
resource "azurerm_virtual_network" "net-1" {
   name                = var.reseau
   address_space       = ["10.0.0.0/16"]
   location            = azurerm_resource_group.test.location
   resource_group_name = azurerm_resource_group.test.name
}
resource "azurerm_subnet" "vm-subnet" {
  name = var.sreseau
  address_prefixes = var.sreseaucidr
  virtual_network_name = azurerm_virtual_network.net-1.name
  resource_group_name  = azurerm_resource_group.test.name
}
resource "azurerm_network_security_group" "linux-vm-nsg" {
  depends_on=[azurerm_virtual_network.net-1]
  name                = var.versionnsg
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_network_security_rule" "http" {
    resource_group_name         = azurerm_resource_group.test.name
    network_security_group_name = azurerm_network_security_group.linux-vm-nsg.name
    name                       = "AllowHTTP"
    description                = "Allow HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"

}
resource "azurerm_network_security_rule" "ssh" {
    resource_group_name         = azurerm_resource_group.test.name
    network_security_group_name = azurerm_network_security_group.linux-vm-nsg.name
    name                       = "AllowSSH"
    description                = "Allow SSH"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
}
resource "azurerm_subnet_network_security_group_association" "linux-vm-nsg-association" {
  depends_on=[azurerm_virtual_network.net-1,azurerm_network_security_group.linux-vm-nsg]
  subnet_id                 = azurerm_subnet.vm-subnet.id
  network_security_group_id = azurerm_network_security_group.linux-vm-nsg.id
}

resource "azurerm_public_ip" "linux-vm-ip" {
  depends_on=[azurerm_subnet.vm-subnet]
  name                = "linux-vm-ip"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "linux-vm-nic" {
  depends_on=[azurerm_subnet.vm-subnet]
  name                = "networkinterface"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
    ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-vm-ip.id
  }
}
resource "azurerm_ssh_public_key" "clessh" {
  name                = "cle"
  resource_group_name = var.environment
  location            = var.location
  public_key          = file("/home/azureuser/terraform/yes.pub")
}
resource "azurerm_linux_virtual_machine" "VM" {
  name                = "VM1"
  resource_group_name = var.environment
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.linux-vm-nic.id]
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/azureuser/terraform/yes.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
