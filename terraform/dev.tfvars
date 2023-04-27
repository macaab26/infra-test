aws_region        = "us-east-1"

# Subnets
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.100.0/24", "10.10.101.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]
db_subnets         = ["10.10.10.0/24", "10.10.11.0/24"]

# Tags
app_name        = "ops-demo-app"
app_environment = "dev"

# DB
db_username = "dev"
db_port     = 5432
db_name     = "demo"