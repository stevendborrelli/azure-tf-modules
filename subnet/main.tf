variable name { 
   default = "terraform"
   description = "Name of the virtual network"
}

variable address_prefixes {
  default = [ "10.0.0.0/24" ] 
  description = "List of CIDRs for the subnets."
}

variable resource_group_name {
  default = ""
  description = "Resource group name"
}

variable virtual_network_name {
  default = ""
  description = "Virtual network name"
}

resource "azurerm_subnet" "sb"  { 
  count = "${length(var.address_prefixes)}" 
  name  = "${var.name}-subnet-${count.index}"
  resource_group_name = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix = "${element(var.address_prefixes,count.index)}"
}

output "ids" {
  value = [ "${azurerm_subnet.sb.*.id}" ]
}

