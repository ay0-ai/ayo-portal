locals {
  location = "southeastasia"
  rg_name  = "resource-ayo-ai"
  prefix   = "ayo"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = local.location
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "${local.prefix}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.prefix}-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    # B-series burstable — budget-conscious
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 30
    temporary_name_for_rotation = "tempdefault"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/18"
  }

  tags = {
    environment = "production"
    project     = "ayo-portal"
  }
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "${local.prefix}-pg"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "16"
  administrator_login           = "ayoadmin"
  administrator_password        = var.pg_admin_password
  storage_mb                    = 32768
  # Burstable B1ms — cheapest tier
  sku_name                      = "B_Standard_B1ms"
  zone                          = "1"
  public_network_access_enabled = false

  tags = {
    environment = "production"
    project     = "ayo-portal"
  }
}

# Allow AKS subnet to access PostgreSQL
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Redis Cache
resource "azurerm_redis_cache" "main" {
  name                          = "${local.prefix}-redis"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  capacity                      = 0
  family                        = "C"
  # Basic C0 — cheapest tier
  sku_name                      = "Basic"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {}

  tags = {
    environment = "production"
    project     = "ayo-portal"
  }
}
