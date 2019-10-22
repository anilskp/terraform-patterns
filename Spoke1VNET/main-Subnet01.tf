
# variable "ThisSubnetname" {
#   default = "Apps"
# }
# variable "ThisNetworkSecurityGroup" {
#   default = "Apps-Subnet-nsg"
# }

locals {
  ThisSubnetname01 = "Apps"
  ThisNetworkSecurityGroup01 = "Apps-Subnet-nsg"
}

locals {
  common_tags1 = {
     Owner = "${var.Owner}"
     Environment = "${var.Environment}"
     CC = "${var.CC}"
  }
}


resource "azurerm_subnet" "sub" {
  name                      = "${local.ThisSubnetname01}"
  resource_group_name       = "${azurerm_resource_group.vnet.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  address_prefix            = "10.4.4.0/22"
  
  #network_security_group_id = "${azurerm_network_security_group.spoke.id}"
}

resource "azurerm_network_security_group" "sub" {
  name                = "${local.ThisNetworkSecurityGroup01}"
  location            = "${azurerm_virtual_network.vnet.location}"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  tags = "${merge( local.common_tags)}"

  security_rule {
    name                       = "UDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.189.3.0/24"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "sub" {
  subnet_id                 = "${azurerm_subnet.sub.id}"
  network_security_group_id = "${azurerm_network_security_group.sub.id}"
}
 
