terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
    skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "metodirg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_service_plan" "metodiasp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.metodirg.name
  location            = azurerm_resource_group.metodirg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "metodialwa" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.metodirg.name
  location            = azurerm_service_plan.metodiasp.location
  service_plan_id     = azurerm_service_plan.metodiasp.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.metodidatabase.name};User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.metodirg.name
  location                     = azurerm_resource_group.metodirg.location
  version                      = "12.0"
  administrator_login          = var.sql_username
  administrator_login_password = var.sql_password
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "metodidatabase" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "metodiafr" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "metodiscv" {
  app_id                 = azurerm_linux_web_app.metodialwa.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}