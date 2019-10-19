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
  address_prefix            = "10.0.2.0/27"
  
  #network_security_group_id = "${azurerm_network_security_group.spoke.id}"
}

resource "azurerm_network_security_group" "sub" {
  name                = "${var.NetworkSecurityGroup}"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroupname}"
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
 