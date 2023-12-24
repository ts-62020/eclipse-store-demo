
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
  blob_properties {
    cors_rule {
      allowed_headers    = var.allowed_headers
      allowed_methods    = var.allowed_methods
      exposed_headers    = var.exposed_headers
      max_age_in_seconds = var.max_age_in_seconds
      allowed_origins    = var.allowed_origins
    }
  }
}

resource "azurerm_storage_container" "sc" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.container_access_type

  lifecycle {
    prevent_destroy = true
  }
}

output "storage_account_key" {
  value     = azurerm_storage_account.sa.primary_access_key
  sensitive = true
}
