run terraform apply # Create all resources in fortimanager ( based on if install_package is set to yes or no, it will push package )

comment postgress from terraform.tfvars, this is scenario where i want to remove postgres service from consul and that should remove all the configuration related to postgres from fortimanager

# Above gives me error with custom_service, as looks like unlock runs before it tries to remove custom_service.
