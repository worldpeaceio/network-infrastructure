WORKDIR := /workspace
DOCKER_RUN := docker run --rm -it -v `pwd`/src:$(WORKDIR):delegated -w $(WORKDIR)
TERRAFORM_IMAGE := hashicorp/terraform:0.12.6
AWS_VAULT_ENV_VARS := -e AWS_VAULT -e AWS_DEFAULT_REGION -e AWS_REGION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_SECURITY_TOKEN
TERRAFORM_RUN := $(DOCKER_RUN) $(AWS_VAULT_ENV_VARS) $(TERRAFORM_IMAGE)

all: lint terraform_init terraform_plan

deploy: terraform_init terraform_apply

lint:
	$(TERRAFORM_RUN) fmt

terraform_init: 
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) init

terraform_plan:
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) plan

terraform_apply:
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) apply