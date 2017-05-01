
user_dataに`ssm-agent`をインストールする処理を入れる

```bash
#---snip---

# Install JQ JSON parser
yum install -y jq aws-cli vim-enhanced
# Get the current region from the instance metadata
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
# Install the SSM agent RPM
yum install -y https://amazon-ssm-$region.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm

#---snip---
```
