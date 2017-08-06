variable "service_api_id" {}
variable "resource_id" {}
variable "region" {}
variable "lambda_arn" {}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${var.service_api_id}"
  resource_id   = "${var.resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "redirect_service_api_integration" {
  depends_on              = ["aws_api_gateway_method.method"]
  rest_api_id             = "${var.service_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST" // it has to be post for lambdas
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"

  request_templates {
    "application/json" = "{\"name\": \"$util.escapeJavaScript($input.params().get('path').get('name'))\"}"
  }
}

resource "aws_api_gateway_method_response" "301" {
  depends_on  = ["aws_api_gateway_integration.redirect_service_api_integration"]
  rest_api_id = "${var.service_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "301"

  response_parameters = {
    "method.response.header.Location" = true
    "method.response.header.Cache-Control" = true
    "method.response.header.ETag" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "redirect_service_api_response" {
  depends_on  = ["aws_api_gateway_method_response.301"]
  rest_api_id = "${var.service_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.301.status_code}"

  response_parameters = { 
    "method.response.header.Location" = "integration.response.body.location"
    "method.response.header.Cache-Control" = "integration.response.body.cache"
    "method.response.header.ETag" = "integration.response.body.etag"
  }
  response_templates {
    "application/json" = ""
  }
}