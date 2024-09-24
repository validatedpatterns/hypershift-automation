# HyperShift Automation

This is an ansible playbook that creates IAM roles/policies and deploys/destroys hypershift clusters

### Prerequisites | Assumptions
This automation makes certain assumptions:
1. Existing openshift cluster with multicluster-engine configured with hypershift feature enabled
1. Ansible is installed on your system, with kuberenetes.core collections
1. `oc` and `hcp` binaries installed and in your path
1. Pull secret from "https://console.redhat.com"
1. AWS credentials with permissions to create IAM roles and policies

### Configurable Variables

This list of variables are for the cluster lifecycle. 

| parameter | default | description |
|-----------|---------|-------------|
| create    | false   | set true to create cluster |
| destroy   | false   | set true to destroy cluster |
| create_iam | false | set true to create iam roles and policies | 
| name | `hcpdflt` | cluster name ( also used for infraID) |
| replicas | `1` | Number of machines to create |
| instance_type | `m5.xlarge` | AWS Machine type |
| domain | `example.com` | base domain for route53 and cluster deployment |
| region | `us-west-2` | default region to deploy resources |
| image | `latest` | OpenShift version to deploy |


### Default Variables 

These variables are default names and paths to various things required for deploying clusters

| variable | default | description |
|----------|---------|-------------|
| hcp | hosted-control-planes | Generic label for a resource |
| gather_facts | false | speed ansible up |
| deployment_dir | `"{{lookup('ansible.builtin.env','HOME')}}/clusters/hcp"` | Creates an artifact directory in $HOME |
| pull_secret_path | `"{{lookup('ansible.builtin.env', 'HOME')}}/.pullsecret.json"` | Looks for pull secret in $HOME/.pullsecret.json |
| sts_creds | dir: `"{{lookup('ansible.builtin.env','HOME')}}/.aws/sts-creds"` <br /> file: `sts-creds.json` | Creates creds directory in $HOME <br /> Name of the sts config file |
| iam | hcp_role_name: `hypershift_cli_role` <br /> hcp_policy_name: `hypershift_cli_policy` <br /> hcp_users: `{}` | Name of the role for building/destroying clusters <br /> Name of the policy associated with the role <br /> List of users to bind to the role so they can build/destroy clusters |

### Usage

**Help**
`make help` will output the available targets

```shell
Usage:
  make <target>
  iam               Provision IAM roles and policies
  build             Build a hosted (HyperShift) cluster
  destroy           Destroy a hosted (HyperShift) cluster
  info              Get the connection information for the managed cluster
  get-clusters      Get the hostedclusters
```

#### Build a cluster

1. Update vars.yml 
1. `make build`

#### Accessing your cluster:

You can grab your logon information directly from the deployment directory. If you left the defaults this will be in $HOME/clusters/hcp/<cluster_name>.

Inside this directory will be a file with the following access information:

```
Use the following information to access your cluster:

clusterName is: keycloak

infraID: keycloak

Region: us-west-2

OpenShift Console: https://console-openshift-console.apps.keycloak.aws.validatedpatterns.io

Username and Password for login: kubeadmin/12345-abcde-67890-fghij

The kubeconfig is on the local filesystem: export KUBECONFIG=/home/jrickard/clusters/hcp/keycloak/kubeconfig
```

#### Destroy a cluster

`make destroy` 


#### Create IAM role and policy

`make iam`

#### List the existing clusters running:

`make get-clusters`