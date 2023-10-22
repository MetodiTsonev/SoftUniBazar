variable "resource_group_name" {
  type        = string
  description = "This is the resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "This is the resource group location"
}

variable "app_service_plan_name" {
  type        = string
  description = "This is the app service plan name"
}

variable "app_service_name" {
  type        = string
  description = "This is the app service name"
}

variable "sql_server_name" {
  type        = string
  description = "This is the sql server name"
}

variable "sql_database_name" {
  type        = string
  description = "This is the sql database name"
}

variable "sql_username" {
  type        = string
  description = "This is the sql username"
}

variable "sql_password" {
  type        = string
  description = "This is the sql password"
}

variable "firewall_rule_name" {
  type        = string
  description = "This is the firewall name"
}

variable "repo_URL" {
  type        = string
  description = "This is the repo URL"
}