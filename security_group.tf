resource "aws-security-group" "alb" {
  name        = "${local.app}-alb"
  description = "For ALB."
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow HTTP from ALL."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all to outbound."
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全てのプロトコルを指定
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.app}-alb"
  }
}

resource "aws-security-group" "ecs" {
  name        = "${local.app}-ecs"
  description = "For ECS."
  vpc_id      = module.vpc.vpc_id
  egress {
    description = "Allow all to outbound."
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # 全てのプロトコルを指定
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.app}-ecs"
  }
}

resource "aws-security-group-role" "ecs_from_alb" {
  description              = "Allow 8080 from Security Group for ALB."
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}