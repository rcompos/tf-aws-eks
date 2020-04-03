# AWS EKS Terraform

Terraform for creating AWS EKS clusters.

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
# Variables
variable "region" {
  default = "us-west-2"
}
```

Optional: Adjust worker nodes in _main.tf_.

```
  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    #{
    #  name                          = "worker-group-2"
    #  instance_type                 = "t2.medium"
    #  additional_userdata           = "echo foo bar"
    #  additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    #  asg_desired_capacity          = 1
    #},
  ]
```

# Create Kubernetes Cluster

Run terraform to create Kubernetes cluster.  

```
⇒ terraform init  
⇒ terraform plan  
⇒ terraform apply  
```

Get LoadBalancer service hostname.

```
⇒ cat service-host.txt
aa134b5e044284b278320d44958d4fa8-979909689.us-west-2.elb.amazonaws.com
```

View service.

```
⇒ curl http://aa134b5e044284b278320d44958d4fa8-979909689.us-west-2.elb.amazonaws.com
 _________________
< E Pluribus Unix >
 -----------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Uninstall Helm chart cowsaid.  Or delete AWS load balancer created for service,
otherwise destroy will failing leaving danglers.

```
⇒ helm --kubeconfig=kubeconfig_test-eks-BgQLqhkO -n cowsaid uninstall cowsaid
```

Destroy cluster.  

```
⇒ terraform destroy  
```
