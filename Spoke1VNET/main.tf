


provider azurerm {
    subscription_id = "11a0fcee-66ee-4603-b871-79d050820de1"
    
}


locals {
  common_tags = {
     Owner = "${var.Owner}"
     Environment = "${var.Environment}"
     CC = "${var.CC}"
  }

  # extra_tags  = {
  #   network = "${var.network1_name}"
  #   support = "${var.network_support_name}"
  # }
}


resource "azurerm_resource_group" "vnet"{

name     = "${var.resourcegroupname}"
location = "${var.location}"
tags = "${merge( local.common_tags)}"
#tags = "${merge( local.common_tags, local.extra_tags)}"

}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnetname}"
  location            = "${azurerm_resource_group.vnet.location}"
  resource_group_name = "${azurerm_resource_group.vnet.name}"
  address_space       = ["11.0.0.0/16"]
  tags = "${merge( local.common_tags)}"
  
}

resource "azurerm_subnet" "vnet" {
  name                      = "${var.Subnetname}"
  resource_group_name       = "${azurerm_resource_group.vnet.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  address_prefix            = "11.0.1.0/25"
  
  #network_security_group_id = "${azurerm_network_security_group.spoke.id}"
}


resource "azurerm_network_security_group" "vnet" {
  name                = "${var.NetworkSecurityGroup}"
  location            = "${azurerm_resource_group.vnet.location}"
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

resource "azurerm_subnet_network_security_group_association" "vnet" {
  subnet_id                 = "${azurerm_subnet.vnet.id}"
  network_security_group_id = "${azurerm_network_security_group.vnet.id}"
}