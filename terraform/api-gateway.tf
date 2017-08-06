/**
 * API Gateway
 */
resource "aws_api_gateway_rest_api" "redirect_service_api" {
  name        = "redirect-service"
  description = "Redirect Service"
}


resource "aws_api_gateway_account" "redirect_service_api" {
  cloudwatch_role_arn = "${aws_iam_role.redirect_service_role.arn}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.redirect_service_api.id}/*/${aws_api_gateway_method.method.http_method}/*"
}

resource "aws_api_gateway_deployment" "redirect_service_api_deploy" {
  depends_on = ["aws_api_gateway_method.method"]

  rest_api_id = "${aws_api_gateway_rest_api.redirect_service_api.id}"
  stage_name  = "prod"
}
