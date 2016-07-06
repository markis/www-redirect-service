/*
 * Terraform State persistance location.
 * Unfortunately it has to be hard coded here
 */
terraform {
  backend "s3" {
    bucket = "terraform-status"
    key    = "hello_lambda.tfstate"
    # Note the terraform state file can be stored in a different region than where the api is deployed
    region = "us-east-1" 
  }
}

/*
 * Terraform AWS provider
 * This will dictate which region the Hello Lambda API is deployed
 */
provider "aws" {
  region = "us-east-1"
}

module "hello_lambda" {
  source        = "./terraform"
  lambda_folder = "${path.module}/src/"
}
