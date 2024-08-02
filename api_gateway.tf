resource "aws_security_group" "dev_sg" {
  name = "dev_lb_sg"
  vpc_id = data.aws_vpc.dev_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dev_lb_sg"
  }
}

resource "aws_apigatewayv2_vpc_link" "dev_vpc_link" {
  name               = "dev_vpc_link"
  security_group_ids = [aws_security_group.dev_sg.id]
  subnet_ids         = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id, data.aws_subnet.private_3.id]

  tags = {
    Usage = "dev_vpc_link"
  }
}

resource "aws_apigatewayv2_api" "dev_api" {
  name = "dev"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "dev_integration" {
  api_id           = aws_apigatewayv2_api.dev_api.id
  description      = "HTTP_PROXY integration for dev"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.dev_listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.dev_vpc_link.id

  tls_config {
    server_name_to_verify = "steverhoton.com"
  }
}

resource "aws_apigatewayv2_route" "dev_route" {
  api_id    = aws_apigatewayv2_api.dev_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.dev_integration.id}"
}
