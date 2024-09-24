NAME ?=
REGION ?=
REPLICAS ?=
TYPE ?=

.PHONY: help
# No need to add a comment here as help is described in common/
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^(\s|[a-zA-Z_0-9-])+:.*?##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: iam
iam: ## Provision IAM roles and policies
	ansible-playbook -e '@vars.yml' -e create=true site.yml

.PHONY: build
build: ## Build a hosted (HyperShift) cluster
	ansible-playbook -e '@vars.yml' -e create=true site.yml

.PHONY: destroy
destroy: ## Destroy a hosted (HyperShift) cluster
	ansible-playbook -e '@vars.yml' -e destroy=true site.yml

.PHONY: info
info: ## Get the connection information for the managed cluster

.PHONY: get-clusters
get-clusters: ## Get the hostedclusters
	@oc get hc -n clusters
