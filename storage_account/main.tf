variable resource_group_name {
  description = "Resource group name"
}

variable location {
   default = "Central US"
   description = "Geographic location"
}

variable account_name {
  description = "Storage account name. Must be unique across Azure." 
}

variable account_type {
  default = "Standard_LRS"
  description = "Storage acount type (i.e.,  Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS)"
}

resource "azurerm_storage_account" "sa" {
    name = "${var.account_name}"
    resource_group_name = "${var.resource_group_name}"
    location = "${var.location}"
    account_type = "${var.account_type}"
}

output "primary_blob_endpoint" {
    value = "${azurerm_storage_account.sa.primary_blob_endpoint}"
}

output "name" {
    value = "${azurerm_storage_account.sa.name}"
}
