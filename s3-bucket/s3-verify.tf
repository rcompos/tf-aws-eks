# AWS S3 bucket

resource null_resource verify-bucket {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner local-exec {
    command = "echo ${aws_s3_bucket.mybucket.id}"
  }
}

