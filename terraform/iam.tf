/**
 * IAM Roles
 */
resource "aws_iam_role" "www_redirect_service_role" {
  name = "www_redirect_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/**
 * Policy Attachments
 */
resource "aws_iam_role_policy_attachment" "lambda-basic-execution" {
  role       = "${aws_iam_role.www_redirect_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}
