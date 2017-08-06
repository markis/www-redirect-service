# Redirect Service

Redirect Service built using AWS API Gateway and Lambda via [terraform](http://terraform.io) from [TravisCI](https://travis-ci.org/mdb/terraform-example).

## Setup

* Clone locally
* Run `make`
* Run `make install`
  * Note, terraform <0.10 has to run `make install` twice before it works due to a race condition with terraform :shrug:

* Visit [travis-ci.org](https://travis-ci.org/profile); activate CI for your fork of this repo.
* In the settings for this project in Travis CI, add the following environment variables:
  * `AWS_ACCESS_KEY_ID=XXXXXXXXXXXX` 
  * `AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXX`
