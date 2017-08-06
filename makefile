.DEFAULT_GOAL := init

init:
	@terraform init
	@terraform plan -out ./.terraform/apply.state

install:
	@terraform apply -state ./.terraform/apply.state

uninstall:
	@terraform destroy

deploy:
	@terraform apply
