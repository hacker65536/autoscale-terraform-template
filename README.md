# autoscale-terraform-template


## getting started
### generate key_pair

```bash
ssh-keygen -t rsa -N "" -f key_pair
```


### use cross account access
if dont use ,skip this.
provider_override.tf

```hcl
provider "aws" {
  profile = "default"
  region  = "us-west-2"

  assume_role {
    role_arn     = "arn:aws:iam::000000000000:role/SwitchRole"
    session_name = "session_name"
  }
}
```

### create env


```bash
terraform env new my-env
```

```bash
$ terraform env list

  default
* my-env-test
  new-env
```
