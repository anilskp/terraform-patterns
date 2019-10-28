


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
  address_space       = ["10.4.0.0/16"]
  tags = "${merge( local.common_tags)}"
  
}
