# Api Gateway and Lambda Reference

Reference repo demonstrating how to continuously deploy via [terraform](http://terraform.io) from [TravisCI](https://travis-ci.org/mdb/terraform-example).

## Setup

* Fork this repo.
* Create an S3 bucket for persisting the `terraform.tfstate` file between deployments.
* Update [`config.tf`](config.tf) with the name and region of your terraform storage bucket.
* Ensure that your configuration works by running:
  * `make`
* Now try deploying:
  * `make install`
  * Note, terraform <0.10 has to run `make install` twice before it works due to a race condition with terraform :shrug:

* Visit [travis-ci.org](https://travis-ci.org/profile); activate CI for your fork of this repo.
* In the settings for this project in Travis CI, add the following environment variables:
  * `AWS_ACCESS_KEY_ID=XXXXXXXXXXXX` 
  * `AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXX`

* At this point you should have an api in api-gateway called `hello-lambda-api`
  * https://XXXXXXX.execute-api.us-east-1.amazonaws.com/prod/markis should return `Hello markis!`