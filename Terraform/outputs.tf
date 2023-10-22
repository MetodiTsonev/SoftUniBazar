output "webapp_url" {
  value = azurerm_linux_web_app.metodialwa.default_hostname
}

output "webapp_ips" {
  value = azurerm_linux_web_app.metodialwa.outbound_ip_addresses
}