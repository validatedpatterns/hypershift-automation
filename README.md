# HyperShift Automation

This is an ansible playbook that deploys | destroys hypershift clusters using Ansible. 

### Prerequisites | Assumptions
This automation makes certain assumptions:
1. Existing openshift cluster with multicluster-engine configured with hypershift TP feature
1. Ansible is installed on your system, with kuberenetes.core collections
1. `oc` and `hypershift` binaries installed and in your path
1. Your pull secret from "https://cloud.redhat.com"
1. An AWS credentials file with a profile that allows you to create cloud resources

### Automation Parameters

| parameter | default | description |
|-----------|---------|-------------|
| create    | false   | set true to create cluster |
| destroy   | false   | set true to destroy cluster |
| deployment_dir | `~/clusters` | Path where cluster config info is stored |
| name | `hcpdflt` | cluster name ( also used for infraID) |
| replicas | `1` | Number of machines to create |
| instance_type | `m5.xlarge` | AWS Machine type |
| domain | `example.com` | base domain for route53 and cluster deployment |
| pull_secret | `~/.pullsecret` | Path to pull secret from console.redhat.com |
| creds | `~/.aws/credentials` | Path to credentials file for aws |
| region | `us-west-2` | default region to deploy resources |
| image | `4.13.22` | OpenShift version to deploy |
| tags | `"key=value,key=value"` | add additional tags for aws resources |
| gather_facts | false | eeedisabled for speed |

### Playbook Stages

This playbook has three stages: 
1. preflight
1. deploy 
1. destroy

Preflight Stage does the following:
- verifies `oc` and `hypershift` binaries exist in your path (`which $binary`)
- verifies your pull secret and aws credentials exist (it does not confirm their validity)

Deploy Stage does the following:
- creates deployment directory
- creates cluster-info.txt with information to access the cluster once deployed
- creates a kubeconfig for accessing the cluster using the kubeconfig
- creates a hostedcluster 

Destroy Stage destroys the hostedcluster and deletes the deployment directory.

### Usage
1. Creating a cluster
```bash
ansible-playbook hcp.yml -e "create=true name=example
```
2. Destroying a cluster
```
ansible-playbook hcp.yml -e "destroy=true name=example
```
