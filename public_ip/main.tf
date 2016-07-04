variable name {
  default = "terraform"
  description = "Base name of the public-ip"
}

variable count {
  default = 1
  description = "Number of Public Ips to create"
}

variable count_offset {
   default = 0
   description = "Start Interface numbering from this value. If you set it to 100, servers will be numbered -101, 102,..."
}

variable count_format {
   default = "%02d"
   description = "Server numbering format (-01, -02, etc.) in printf format"
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
  name  = "${var.name}-public-ip-${format(var.count_format, var.count_offset + count.index + 1)}"
  resource_group_name = "${var.resource_group_name}"
  public_ip_address_allocation = "${var.public_ip_address_allocation}"
}

output "ids" {
  value = [ "${azurerm_public_ip.pi.*.id}" ]
}

output "ip_addresses" {
  value = [ "${azurerm_public_ip.pi.*.ip_address}" ]
}
