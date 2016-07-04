variable location { default = "Central US" }
variable name { default = "sbterraform2" }

variable network_address_space  { default = "10.0.0.0/16" }

variable subnet_address_prefixes { 
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable control_count { default = 3 }
variable datacenter { default = "azure" }
variable admin_username { default = "terraform" }
variable admin_password { default = "TF-mantl1" }


