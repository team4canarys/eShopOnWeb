output "resource_group_name" {
  value = azurerm_resource_group.devopsathon.name
}

output "sql_server_name" {
  value = azurerm_mssql_server.sqlserver.id
}

