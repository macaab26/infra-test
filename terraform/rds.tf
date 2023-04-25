module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "${var.app_name}-${var.app_environment}-db"

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t4g.large"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = "replicaPostgresql"
  username = "replica_postgresql"
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [module.security_group.security_group_id]

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.app_name}-${var.app_environment}-rds-sg"
  vpc_id      = aws_vpc.aws-vpc.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.db_port
      to_port     = var.db_port
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = aws_vpc.aws-vpc.cidr_block
    },
  ]

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}