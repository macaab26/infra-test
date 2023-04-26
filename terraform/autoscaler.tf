module "ecs-service-autoscaling" {
  source  = "cn-terraform/ecs-service-autoscaling/aws"
  version = "1.0.6"
  
  ecs_cluster_name = aws_ecs_cluster.aws-ecs-cluster.name
  ecs_service_name = aws_ecs_service.aws-ecs-service.name
  name_prefix      = var.app_name

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }  

  depends_on = [aws_ecs_service.aws-ecs-service]
}