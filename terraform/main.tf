
locals {
  stage    = "demo"
  prefix   = "eclipse-store-${local.stage}"
  location = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = local.location
}

module "storage_account" {
  source = "./modules/storage"

  depends_on = [azurerm_resource_group.rg]

  resource_group_name    = azurerm_resource_group.rg.name
  storage_account_name   = "eclipsestoredemostorage"
  storage_container_name = "${local.prefix}-blobstorage"
}
