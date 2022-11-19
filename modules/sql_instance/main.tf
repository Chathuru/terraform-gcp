locals {
  databases = flatten([
    for db_instance_name, db_list in var.mysql_databases : [
      for database in db_list.db_list : {
        instance_name = db_instance_name
        database      = database
      }
    ]
  ])

  users = flatten([
    for db_instance_name, user_list in var.mysql_databases : [
      for user in user_list.user_list : {
        instance_name = db_instance_name
        user          = user.name
        host          = user.host
      }
    ]
  ])
}

data "google_secret_manager_secret_version" "passwords" {
  count = length(local.users)

  secret  = local.users[count.index].user
  project = var.project_id
}

resource "google_sql_database_instance" "sql_database_instance" {
  provider = google-beta
  for_each = var.mysql_databases

  name                = each.key
  region              = lookup(each.value, "region")
  project             = var.project_id
  database_version    = lookup(each.value, "database_version")
  deletion_protection = var.deletion_protection

  settings {
    tier              = lookup(each.value, "db_instance_tier")
    availability_type = lookup(each.value, "availability_type")
    disk_type         = lookup(each.value, "disk_type")
    disk_size         = lookup(each.value, "disk_size")
    disk_autoresize   = lookup(each.value, "disk_autoresize")

    ip_configuration {
      ipv4_enabled       = lookup(each.value, "public_access")
      private_network    = var.vpc_id
      allocated_ip_range = var.vpc_id != null && lookup(each.value, "private_service_connection_name", "") != "" ? lookup(each.value, "private_service_connection_name") : null
      require_ssl        = true

      dynamic "authorized_networks" {
        for_each = lookup(each.value, "sql_authorized_networks", null)

        content {
          name  = authorized_networks.value["name"]
          value = authorized_networks.value["value"]
        }
      }
    }

    backup_configuration {
      #binary_log_enabled = var.binary_log_enabled
      #enabled            = var.backup_enable || var.binary_log_enabled ? true : var.backup_enable
      binary_log_enabled = lookup(each.value, "binary_log_enabled", false)
      enabled            = lookup(each.value, "backup_enable", false) || lookup(each.value, "binary_log_enabled", false) ? true : false

      dynamic "backup_retention_settings" {
        #for_each = var.backup_enable || var.binary_log_enabled ? { dummy : "dummy" } : {}
        for_each = lookup(each.value, "backup_enable", false) || lookup(each.value, "binary_log_enabled", false) ? { dummy : "dummy" } : {}
        content {
          retained_backups = lookup(each.value, "retained_backups")
          retention_unit   = var.retention_unit
        }
      }
    }
  }
}

resource "google_sql_ssl_cert" "client_cert" {
  for_each = var.mysql_databases

  common_name = each.key
  instance    = each.key
  project     = var.project_id

  depends_on = [google_sql_database_instance.sql_database_instance]
}

resource "google_sql_database" "database" {
  count = length(local.databases)

  name     = local.databases[count.index].database
  instance = local.databases[count.index].instance_name
  project  = var.project_id

  depends_on = [google_sql_database_instance.sql_database_instance]
}

resource "google_sql_user" "users" {
  count = length(local.users)

  name     = local.users[count.index].user
  instance = local.users[count.index].instance_name
  host     = local.users[count.index].host
  password = data.google_secret_manager_secret_version.passwords[count.index].secret_data
  project  = var.project_id

  depends_on = [data.google_secret_manager_secret_version.passwords, google_sql_database_instance.sql_database_instance]
}

resource "google_sql_database_instance" "sql_database_replica" {
  provider = google-beta
  for_each = var.mysql_replica_databases

  name                 = join("-", [each.key, "replica"])
  master_instance_name = each.key
  region               = lookup(each.value, "region")
  project              = var.project_id
  database_version     = lookup(each.value, "database_version")
  deletion_protection  = var.deletion_protection

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = lookup(each.value, "db_instance_tier")
    availability_type = lookup(each.value, "availability_type")
    disk_type         = lookup(each.value, "disk_type")
    disk_size         = lookup(each.value, "disk_size")

    ip_configuration {
      ipv4_enabled       = lookup(each.value, "public_access")
      private_network    = var.vpc_id
      allocated_ip_range = var.vpc_id != null && lookup(each.value, "private_service_connection_name", "") != "" ? lookup(each.value, "private_service_connection_name") : null
      require_ssl        = true

      dynamic "authorized_networks" {
        for_each = lookup(each.value, "sql_authorized_networks", null)

        content {
          name  = authorized_networks.value["name"]
          value = authorized_networks.value["value"]
        }
      }
    }
  }

  depends_on = [google_sql_database_instance.sql_database_instance]
}
