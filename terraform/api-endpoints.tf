/**
 * API Gateway - Hello Lambda Endpoint
 */
resource "aws_api_gateway_resource" "hello_lambda_api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_lambda_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.hello_lambda_api.root_resource_id}"
  path_part   = "{name}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.hello_lambda_api.id}"
  resource_id   = "${aws_api_gateway_resource.hello_lambda_api_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_lambda_api_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.hello_lambda_api.id}"
  resource_id             = "${aws_api_gateway_resource.hello_lambda_api_resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST" // it has to be post for lambdas
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"

  request_templates {
    "application/json" = <<EOF
      {"name": "$util.escapeJavaScript($input.params().get('path').get('name'))"}
    EOF
  }
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_lambda_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_lambda_api_resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "hello_lambda_api_response" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_lambda_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_lambda_api_resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
}