provider azurerm {
    subscription_id = "11a0fcee-66ee-4603-b871-79d050820de1"
    
}

locals {
  vnetname1 = "qrhub1-vnet"
  resourcegroupname1 = "qrhub1-rg"

  vnetname2 = "qrspoke1-vnet"
  resourcegroupname2 = "qrspoke1-rg"
  
}

locals {
  common_tags = {
     Owner = "${var.Owner}"
     Environment = "${var.Environment}"
     CC = "${var.CC}"
  }
}

data  "azurerm_resource_group" "vnet1"{

name     = "${local.resourcegroupname1}"


}
data "azurerm_virtual_network" "vnet1" {
  name                = "${local.vnetname1}"
  resource_group_name = "${data.azurerm_resource_group.vnet1.name}"
  #address_space       = ["10.3.0.0/16"]
  # tags = "${merge( local.common_tags)}"
  
}

data  "azurerm_resource_group" "vnet2"{

name     = "${local.resourcegroupname2}"


}
data "azurerm_virtual_network" "vnet2" {
  name                = "${local.vnetname2}"
  resource_group_name = "${data.azurerm_resource_group.vnet2.name}"
  #address_space       = ["10.4.0.0/16"]
  # tags = "${merge( local.common_tags)}"
  
}


resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "peer1to2"
  resource_group_name       = "${data.azurerm_resource_group.vnet1.name}"
  virtual_network_name      = "${data.azurerm_virtual_network.vnet1.name}"
  remote_virtual_network_id = "${data.azurerm_virtual_network.vnet2.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "peer2to1"
  resource_group_name       = "${data.azurerm_resource_group.vnet2.name}"
  virtual_network_name      = "${data.azurerm_virtual_network.vnet2.name}"
  remote_virtual_network_id = "${data.azurerm_virtual_network.vnet1.id}"

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}
