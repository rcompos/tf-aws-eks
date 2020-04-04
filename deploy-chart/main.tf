# Deploy Helm chart

locals {
   cluster_name = var.cluster_name
   repo_dir = "repos"
   repo = "cowsaid"
   #url = "https://github.com/rcompos/cowsaid"
   url = "https://github.com/rcompos/${local.repo}"
   outfile = "service-host.txt"
   kdir = "../basic"
   kfile = "${local.kdir}/kubeconfig_${local.cluster_name}"
}

resource null_resource after {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner local-exec {
    command = "echo Using Kubernetes config: ${local.kfile}"
  }

  provisioner local-exec {
    command = "ls ${local.repo_dir}/${local.repo} || mkdir ${local.repo_dir}; cd ${local.repo_dir} && git clone ${local.url}"
  }
  provisioner local-exec {
    command = "kubectl --kubeconfig=${local.kfile} get ns ${local.repo} || kubectl --kubeconfig=${local.kfile} create ns ${local.repo}"
  }
  provisioner local-exec {
    command = "helm --kubeconfig=${local.kfile} install ${local.repo} --namespace ${local.repo} ./${local.repo_dir}/${local.repo}/${local.repo}-helm --set service.type=LoadBalancer"
    on_failure = continue
  }
  provisioner local-exec {
    command = "kubectl --kubeconfig=${local.kfile} -n ${local.repo} get svc ${local.repo} -o jsonpath='{.status.loadBalancer.ingress[].hostname}' | tee ${local.outfile}"
    on_failure = continue
  }

}

