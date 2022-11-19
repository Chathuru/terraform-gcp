project_id    = "test"
network_name  = "core-vpc"
deploy_region = "us-east1"
subnets = [{
  subnet_name           = "private-subnet"
  subnet_cidr           = "10.22.132.0/24"
  description           = "vpc"
  subnet_private_access = "true"
}]

private_ip_address = [
  {
    name : "private-mysql"
    prefix_length : 24
    address : "10.23.3.0"
  },
  {
    name : "private-redis"
    prefix_length : 24
    address : "10.23.4.0"
  }
]

router_name            = "cloud-router"
nat_gateway_name       = "nat-gateway"
nat_subnetworks        = ["private-subnet"]
cluster_name           = "gke-cluster"
gke_subnetwork_name    = "private-subnet"
cluster_node_locations = ["us-east1-b", "us-east1-c", "us-east1-d"]
node_pools = [{
  pool_name      = "pool_name"
  location       = "us-east1"
  node_locations = "us-east1-b,us-east1-c,us-east1-d"
  node_count     = "1"
  image_type     = "COS_CONTAINERD"
  machine_type   = "n2-standard-4"
  labels = {
    node_pool_name = "node_pool_name"
  }
  }
]

mysql_allow_ip_range  = "10.22.132.0/24"
mysql_subnetwork_name = "private-mysql"
mysql_databases = {
  mysql = {
    region            = "us-east1"
    database_version  = "MYSQL_8_0"
    db_instance_tier  = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_type         = "PD_SSD"
    disk_size         = 20
    disk_autoresize   = true
    public_access     = true
    private_service_connection_name = "private-mysql"
    binary_log_enabled              = true
    backup_enable                   = true
    retained_backups                = 1
    sql_authorized_networks = {}
    db_list = ["db1"]
    user_list = {
      user1 = {
        name = "user1"
        host = "%"
      }
    }
  }
}

redis_subnetwork_name = "private-redis"
redis_instances = {
  redis = {
    tier           = "BASIC"
    version        = "REDIS_6_X"
    memory_size_gb = 1
    connect_mode   = "PRIVATE_SERVICE_ACCESS"
    location_id    = "us-east1-b"
  }
}

cloud_build_triggers = {
  access = {
    git_repo    = "https://github.com/Chathuru/terraform-gcp.git"
    description = "test-repo"
  }
}

users_credentials = {
  user1 = "asd123"
}

security_policies = {
  "https-allow" = {
    rules = {
      "allow-all" = {
        action        = "allow",
        priority      = "100",
        src_ip_ranges = ["0.0.0.0/0"]
      }
      "Default rule, higher priority overrides it" = {
        action        = "deny(403)",
        priority      = "2147483647",
        src_ip_ranges = ["*"]
      }
    }
  }
}

gke_authorized_networks = {
  cloud_shell-0 = {
    cidr_block   = "35.0.0.0/8",
    display_name = "asia-southeast1"
    }
  }
}
