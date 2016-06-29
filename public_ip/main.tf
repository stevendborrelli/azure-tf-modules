variable name {
  default = "terraform"
  description = "Base name of the public-ip"
}

variable count {
  default = 1
  description = "Number of Public Ips to create"
}

variable resource_group_name {
  default = ""
  description = "Resource group name"
}

variable location {
  default = "Central US"
  description = "Azure location for the public IP"
}

variable public_ip_address_allocation {
  default = "static"
  description = "Is IP addres static or dynamic"
}

resource "azurerm_public_ip" "pi" {
  count = "${var.count}"
  location = "${var.location}"
  name  = "${var.name}-public-ip-${count.index}"
  resource_group_name = "${var.resource_group_name}"
  public_ip_address_allocation = "${var.public_ip_address_allocation}"
}

output "ids" {
  value = "${list(azurerm_public_ip.pi.*.id)}"
}

output "ip_address" {
  value = "${list(azurerm_public_ip.pi.*.ip_address)}"
}
