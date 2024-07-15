# ALB の作成
resource "aws_lb" "alb" {
  name               = "${local.app}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
}

# ALB のリスナー作成(接続リクエストをチェックするプロセス)
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

# ALB のリスナーのルールを作成
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn

  # ルーティング設定
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  # マッチするパスパターンのリストを設定
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "target_group" {
  # 3 回連続で 5 秒以内にレスポンスが返って来ればコンテナが生きているとみなされる
  name        = "${local.app}-target_group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
  health_check {
    healthy_threshold = 3
    interval          = 30
    path              = "/health_checks"
    protocol          = "HTTP"
    timeout           = 5
  }
}