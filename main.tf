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

module "public_ips_control" {
  name = "control"
  source = "github.com/stevendborrelli/azure-tf-modules//public_ip"
  location = "${var.location}"
  resource_group_name = "${module.resource_group.name}"
  count = 3 
}

