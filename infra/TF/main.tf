resource "azurerm_resource_group" "devopsathon" {
  name     = "team4-dotnet"
  location = "eastus"
}
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "team4-sqlserver"
  resource_group_name          = azurerm_resource_group.devopsathon.name
  location                     = azurerm_resource_group.devopsathon.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Canarys@123"
}

resource "azurerm_mssql_database" "db" {
  name           = "CatalogDb"
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  tags = {
    foo = "bar"
  }
}

resource "azurerm_mssql_database" "db1" {
  name           = "IdentityDb"
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  tags = {
    foo = "bar"
  }
}
