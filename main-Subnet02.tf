
# variable "ThisSubnetname" {
#   default = "AzureBastionSubnet"
# }
# variable "ThisNetworkSecurityGroup" {
#   default = "Bastion-Subnet-nsg"
# }


locals {
  ThisSubnetname02 = "AzureBastionSubnet"
  ThisNetworkSecurityGroup02 = "Bastion-Subnet-nsg"
}


resource "azurerm_subnet" "sub02" {
  name                      = "${local.ThisSubnetname02}"
  resource_group_name       = "${azurerm_resource_group.vnet.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  address_prefix            = "10.3.2.0/24"
  
  #network_security_group_id = "${azurerm_network_security_group.spoke.id}"
}

resource "azurerm_network_security_group" "sub02" {
  name                = "${local.ThisNetworkSecurityGroup02}"
  location            = "${azurerm_virtual_network.vnet.location}"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  tags = "${merge( local.common_tags)}"

  security_rule {
    name                      = "bastion-in-allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
security_rule {
    name                      = "bastion-control-in-allow"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
  security_rule {
    name                      = "bastion-in-deny"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                      = "bastion-vnet-out-allow1"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
    security_rule {
    name                      = "bastion-vnet-out-allow2"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
    }
  security_rule {
    name                      = "bastion-azure-out-allow"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }
    security_rule {
    name                      = "bastion-out-deny"
    priority                   = 900
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_subnet_network_security_group_association" "sub02" {
  subnet_id                 = "${azurerm_subnet.sub02.id}"
  network_security_group_id = "${azurerm_network_security_group.sub02.id}"
}
 