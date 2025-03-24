## Add resources to contain an OPA server
#
# resource "random_pet" "dns_name_label" {
#   keepers = {
#     rg_id = azurerm_resource_group.rg.id
#   }
# }

# resource "azurerm_resource_group" "rg" {
#   name     = "ml4-opa-svc"
#   location = "North Europe"
# }

# resource "azurerm_container_group" "cg" {
#   name                = "opa"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   ip_address_type     = "public"
#   dns_name_label      = random_pet.dns_name_label.id
#   os_type             = "Linux"

#   container {
#     name   = "opa"
#     image  = "openpolicyagent/opa"
#     cpu    = "1.0"
#     memory = "2.0"

#     ports {
#       port     = 8181
#       protocol = "TCP"
#     }

#     commands = [
#       "/opa",
#       "run",
#       "--server",
#       "--log-format",
#       "text",
#       "--log-level",
#       "debug",
#       "--config-file",
#       "/opa/opa.yaml"
#     ]

#     volume {
#       name       = "main"
#       mount_path = "/"
#       git_repo {
#         url       = "https://github.com/ml4/hc-sec-opasrc"
#         directory = "opa"
#       }
#     }
#   }
# }