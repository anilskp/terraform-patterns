provider azurerm {
    subscription_id = "11a0fcee-66ee-4603-b871-79d050820de1"
    
}


locals {
  common_tags = {
     Owner = "${var.Owner}"
     Environment = "${var.Environment}"
     CC = "${var.CC}"
  }
}

resource "azurerm_subnet" "sub" {
  name                      = "${var.Subnetname}"
  resource_group_name       = "${var.resourcegroupname}"
  virtual_network_name      = "${var.vnetname}"
  address_prefix            = "10.4.8.0/24"
  
  #network_security_group_id = "${azurerm_network_security_group.spoke.id}"
}

resource "azurerm_network_security_group" "sub" {
  name                = "${var.NetworkSecurityGroup}"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroupname}"
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

resource "azurerm_subnet_network_security_group_association" "sub" {
  subnet_id                 = "${azurerm_subnet.sub.id}"
  network_security_group_id = "${azurerm_network_security_group.sub.id}"
}
 