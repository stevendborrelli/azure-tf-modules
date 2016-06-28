variable name { 
   default = "terraform"
   description = "Name of the virtual network"
}
variable location {
  default = "Central US"
  description = "Geographic location of the virtual network"
} 

variable address_space {
  default = "10.0.0.0/16"
  description = "Address space for the virtual networks"
}

variable resource_group_name {
  description = "Resource group name"
}

resource "azurerm_virtual_network" "vn" {
  name                = "${var.name}-network"
  resource_group_name = "${var.resource_group_name}"
  address_space       = ["${split(",",var.address_space)}"]
  location            = "${var.location}"
}


output "id" {
  value = "${azurerm_virtual_network.vn.id}"
}

output "name" {
  value = "${azurerm_virtual_network.vn.name}"
}
