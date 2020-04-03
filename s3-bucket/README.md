# s3-bucket

Terraform for creating an AWS S3 bucket.

* Not publicly accessible  
* Encryption enabled at rest   

AWS credentials must be pre-configured.

# Variables

Specify the AWS region and S3 bucket name in variables.tf.  
The S3 bucket name must be globaly unique.  

```
variable "region" {
  default = "us-west-2"
}

variable "bucket" {
  default = "my-bucket-202004011940-314159"
}
```


# Terraform usage

Run terraform to create bucket.

```
⇒ terraform init
⇒ terraform plan
⇒ terraform apply
```

View bucket in web browser.

```
https://s3.console.aws.amazon.com/s3/buckets/my-bucket-202004011940-314159/
```

View bucket in with AWS CLI.  

```
⇒ aws s3 ls
```

Delete bucket.

```
⇒ terraform destroy
```
