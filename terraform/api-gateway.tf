/**
 * API Gateway
 */
resource "aws_api_gateway_rest_api" "www_redirect_service_api" {
  name        = "www-redirect-service"
  description = "Redirect non-www domains to www domains"
}

resource "aws_api_gateway_account" "www_redirect_service_api" {
  cloudwatch_role_arn = "${aws_iam_role.www_redirect_service_role.arn}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.www_redirect_service_api.id}/*/GET/*"
}

resource "aws_api_gateway_deployment" "www_redirect_service_api_deploy" {
  depends_on        = ["module.default_method", "module.name_method"]
  rest_api_id       = "${aws_api_gateway_rest_api.www_redirect_service_api.id}"
  stage_name        = "prod"
  stage_description = "Deployed at ${timestamp()}" // forces the api to be re-deployed

  lifecycle {
    create_before_destroy = true
  }
}

/**
 * Default Method
 * This attaches the lambda to the root resource
 */
module "default_method" {
  source          = "./method"
  service_api_id  = "${aws_api_gateway_rest_api.www_redirect_service_api.id}"
  resource_id     = "${aws_api_gateway_rest_api.www_redirect_service_api.root_resource_id}"
  region          = "${data.aws_region.current.name}"
  lambda_arn      = "${aws_lambda_function.lambda.arn}"
}

/**
 * Name Method
 * This attaches the lambda to a resource with a path of "{name}"
 */
resource "aws_api_gateway_resource" "www_redirect_service_api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.www_redirect_service_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.www_redirect_service_api.root_resource_id}"
  path_part   = "{path+}"
}

module "name_method" {
  source          = "./method"
  service_api_id  = "${aws_api_gateway_rest_api.www_redirect_service_api.id}"
  resource_id     = "${aws_api_gateway_resource.www_redirect_service_api_resource.id}"
  region          = "${data.aws_region.current.name}"
  lambda_arn      = "${aws_lambda_function.lambda.arn}"
}
