variable location { default = "Central US" }
variable name { default = "sbterraform" }

variable network_address_space  { default = "10.0.0.0/16" }

variable subnet_address_prefixes { 
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ] 
}
