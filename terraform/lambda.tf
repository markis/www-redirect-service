/**
 * Generate Lambda Zip Files
 */
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${var.lambda_folder}"
  output_path = "${path.module}/code.zip"
}

/**
 * Lambda Definitions
 */
resource "aws_lambda_function" "lambda" {
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "redirect-service"
  role             = "${aws_iam_role.redirect_service_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs6.10"
  timeout          = 2
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
}
