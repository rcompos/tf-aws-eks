# tf-aws-eks

Terraform for deploying demo Helm chart.

# Requirements

```
* AWS credentials must be pre-configured (~/.aws)
* Terraform must be installed locally (⇒ brew install terraform)
* Kubectl must be installed locally (⇒ brew install kubectl)
* Helm client must be installed locally (⇒ brew install helm)
```

# Variables

Specify the AWS region in _variables.tf_.

```
variable "cluster_name" {
  default = "dev-eks"
}
```

Run terraform to deploy helm chart into Kubernetes cluster
installed from ../basic directory.

```
⇒ terraform init
⇒ terraform plan
⇒ terraform apply
```

List all helm charts. 
Substitute actual kubeconfig file name for kubeconfig_dev-eks.

```
⇒ helm --kubeconfig=../basic/kubeconfig_dev-eks ls --all-namespaces
```

Delete helm charts when done. Substitute actual namespace and chart name.
Substitute actual kubeconfig file name for kubeconfig_dev-eks.

```
⇒ helm --kubeconfig=../basic/kubeconfig_dev-eks -n <namespace> uninstall <chart>
```

TODO: Destroy helm chart from terraform.

```
⇒ terraform destroy  
```
