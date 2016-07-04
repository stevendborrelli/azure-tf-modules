variable name { 
   default = "terraform"
   description = "Name of the virtual network"
}


variable location {
  default = "Central US"
  description = "Geographic location of the virtual network"
} 

variable role {
  default = ""
  description = "Set role tag "
}


variable datacenter {
  default = ""
  description = "Set datacenter tag"
}

variable count {
  default = 1 
  description = "Number of VMs to provision." 
}

variable count_offset { 
   default = 0 
   description = "Start server numbering from this value. If you set it to 100, servers will be numbered -101, 102,..."
} 

variable count_format { 
   default = "%02d" 
   description = "Server numbering format (-01, -02, etc.) in printf format"
} 

variable subnet_ids {
  default = []
  description = "Subnets for the network interface"
}

variable private_ip_address_allocation {
  default = "dynamic"
  description = "IP assignment for the network interface. Can be static or dynamic: if using static please set private_ip_address"
}

variable private_ip_addresses {
  default = [""]
  description = "Rrivate IP address for the network interface. Required if private_ip_address_allocation is static"
}

variable public_ip_addresses {
  default = [""]
  description = "Optional Public IP addresses assigned to the network interface"
}

variable public_ip_address_ids {
  default = [""]
  description = "Optional Public IP address id to assign to the network interface"
}

variable resource_group_name {
  description = "Resource group name"
}

variable network_security_group_id {
  default = ""
  description = "Optional network security group id to attach to instance"
}

variable vm_name {
  default = "vm"
  description = "Name of the Virtual Machine" 
}

variable vm_size {
  default = "Standard_A1"
  description = "Size of the VM. See https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/"
}

# Storage account to use
variable storage_account_name {
  description = "Azure storage account to use to store OS disk images"
}

variable storage_primary_blob_endpoint {
  description = "Azure storage blob endpoint to use to store OS disk images"
}
# Images to use
# See https://github.com/Azure/azure-quickstart-templates/blob/master/101-vm-simple-windows/azuredeploy.json
variable image_publisher {
  default = "openlogic"
  description = "OS Image publisher"
}

variable image_offer {
  default = "CentOS"
  description = "OS Image offer"
}

variable image_sku {
  default = "7.2"
  description = "OS Image sku"
}

variable image_version {
   default = "latest"
   description = "OS Image version"
}

variable admin_username {
  default = "root"
  description = "Admin account"
}

variable admin_password {
   description = "Admin account password (required)"
}

variable os_disk_name {
   default = "osdisk"
   description = "Base name of the OS disk"
}


# All VMs require a network interface
resource "azurerm_network_interface" "ni" {
    count = "${var.count}"
    name = "${var.vm_name}-ni-${format(var.count_format, var.count_offset + count.index + 1)}"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

    network_security_group_id = "${var.network_security_group_id}"

    ip_configuration {
        name = "${var.vm_name}-ni-${format(var.count_format, var.count_offset + count.index + 1) }"
        subnet_id = "${var.subnet_ids[count.index]}"
        private_ip_address_allocation = "${var.private_ip_address_allocation}"
        #private_ip_address = "${var.private_ip_addresses[count.index]}" #can't be zero yet
        public_ip_address_id = "${var.public_ip_address_ids[count.index]}"
    }
}

resource "azurerm_storage_container" "osdisk" {
    count = "${var.count}"
    name = "${var.vm_name}${var.os_disk_name}${format(var.count_format, var.count_offset + count.index + 1)}"
    storage_account_name = "${var.storage_account_name}"
    resource_group_name = "${var.resource_group_name}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "vm" {
    count = "${var.count}"
    name = "${var.vm_name}-${format(var.count_format, var.count_offset + count.index + 1)}"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"
    network_interface_ids = ["${element(azurerm_network_interface.ni.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_image_reference {
        publisher = "${var.image_publisher}"
        offer = "${var.image_offer}"
        sku = "${var.image_sku}"
        version = "${var.image_version}"
    }

    storage_os_disk {
        name = "${var.vm_name}-${var.os_disk_name}-${format(var.count_format, var.count_offset + count.index + 1)}"
        vhd_uri = "${var.storage_primary_blob_endpoint}${element(azurerm_storage_container.osdisk.*.name, count.index)}/${var.os_disk_name}.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.vm_name}-${format(var.count_format, var.count_offset+count.index+1)}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    tags {
      Name = "${var.vm_name}-${format(var.count_format, var.count_offset + count.index + 1)}"
      sshUser = "${var.admin_username}"
      role = "${var.role}"
      dc = "${var.datacenter}"
  }
}

output "vm_ids" {
  value = "${list(azurerm_virtual_machine.vm.*.id)}"
}

