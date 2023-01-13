.Phony: docs validate

docs:
	terraform-docs -c ./configs/.terraform-docs.yaml  .