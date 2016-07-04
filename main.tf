variable module_base { default = "github.com/stevendborrelli/azure-tf-modules/" }

module "resource_group" {
  source = "github.com/stevendborrelli/azure-tf-modules//resource_group"
  name = "${var.name}"
  location = "${var.location}"
}

module "virtual_network" {
  source = "github.com/stevendborrelli/azure-tf-modules//virtual_network"
  name = "${var.name}"
  location = "${var.location}"
  resource_group_name = "${module.resource_group.name}"
  address_space = "${var.network_address_space}"
}

module "subnet" {
  source = "github.com/stevendborrelli/azure-tf-modules//subnet"
  name = "${var.name}"
  resource_group_name = "${module.resource_group.name}"
  virtual_network_name = "${module.virtual_network.name}"
  address_prefixes = "${var.subnet_address_prefixes}"
}

module "storage_account" {
  source = "github.com/stevendborrelli/azure-tf-modules//storage_account"
  account_name = "${var.name}osdisks"
  resource_group_name = "${module.resource_group.name}"
}

module "public_ips_control" {
  name = "control"
  source = "github.com/stevendborrelli/azure-tf-modules//public_ip"
  location = "${var.location}"
  resource_group_name = "${module.resource_group.name}"
  count = "${var.control_count}"
}

module "vms_control" {
  source = "github.com/stevendborrelli/azure-tf-modules//virtual_machines"
  name = "${var.name}-control"
  count = "${var.control_count}"
  vm_name = "control"
  location = "${var.location}"
  role = "role=control"
  datacenter = "${var.datacenter}"
  resource_group_name = "${module.resource_group.name}"
  subnet_ids = "${module.subnet.ids}"
  storage_account_name = "${module.storage_account.name}"
  storage_primary_blob_endpoint = "${module.storage_account.primary_blob_endpoint}"
  admin_username = "${var.admin_username}"
  admin_password = "${var.admin_password}"
#  public_ip_addresses = "${module.public_ips_control.ip_addresses}"
  public_ip_address_ids = "${module.public_ips_control.ids}"
#  network_security_group_id = "${module.network_security_group_default.id}"
}
