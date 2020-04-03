# Deploy Helm chart

locals {
   repo = "cowsaid"
   url = "https://github.com/rcompos/cowsaid"
   outfile = "service-host.txt"
   //config ="../basic/kubectl"
}

resource null_resource before {
}

# Delay to let cluster come up
resource null_resource delay {
  provisioner local-exec {
    command = "sleep 60"
  }
  triggers = {
    before = "${null_resource.before.id}"
  }
}

resource null_resource after {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner local-exec {
    command = "ls cowsaid || git clone ${local.url}"
  }
  provisioner local-exec {
    command = "kubectl --kubeconfig=${module.eks.kubeconfig_filename} get ns ${local.repo} || kubectl --kubeconfig=${module.eks.kubeconfig_filename} create ns ${local.repo}"
  }
  provisioner local-exec {
    command = "helm --kubeconfig=${module.eks.kubeconfig_filename} install ${local.repo} --namespace ${local.repo} ./${local.repo}/cowsaid-helm --set service.type=LoadBalancer"
    on_failure = continue
  }
  provisioner local-exec {
    command = "kubectl --kubeconfig=${module.eks.kubeconfig_filename} -n ${local.repo} get svc ${local.repo} -o jsonpath='{.status.loadBalancer.ingress[].hostname}' | tee ${local.outfile}"
    on_failure = continue
  }
  depends_on = [null_resource.delay]
}

