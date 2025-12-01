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
	@cat ~/clusters/hcp/${NAME}/cluster-info.txt

.PHONY: get-clusters
get-clusters: ## Get the hostedclusters
	@oc get hc -n clusters

.PHONY: all
all: iam build ## Provision IAM resources and create a cluster

#.PHONY local-setup
#local-setup: ## Configure local machine
#	@sudo dnf install -y ansible
#	@ansible-galaxy collection install -r requirements.yml
#	@curl -Lf -o /tmp/hcp-cli.tar.gz https://developers.redhat.com/content-gateway/file/pub/mce/clients/hcp-cli/2.6.2-7/hcp-cli-2.6.2-7-linux-amd64.tar.gz && tar xvf /tmp/hcp-cli.tar.g

.PHONY: test
test: ## Run all tests
	@cd hcp/tests && bash run-tests.sh

.PHONY: test-expand
test-expand: ## Test cluster expansion logic
	@ansible-playbook -i hcp/tests/inventory hcp/tests/test-expand-clusters.yml

.PHONY: test-vars
test-vars: ## Test variable validation
	@ansible-playbook -i hcp/tests/inventory hcp/tests/test-variables.yml

.PHONY: test-flow
test-flow: ## Test task execution flow
	@ansible-playbook -i hcp/tests/inventory hcp/tests/test-task-flow.yml

.PHONY: test-integration
test-integration: ## Run integration tests
	@ansible-playbook -i hcp/tests/inventory hcp/tests/test-integration.yml
