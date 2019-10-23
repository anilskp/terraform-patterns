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
  address_prefix            = "10.3.3.0/27"
  
  #network_security_group_id = "${azurerm_network_security_group.spoke.id}"
}


 