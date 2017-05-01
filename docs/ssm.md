
`user_data`に`ssm-agent`をインストールする処理を入れる

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

externalの接続が必要なので、instanceが外にアクセスできるようにigwを持つroute tableにsubnetをassociateしている必要がある。  
internalの場合はs3に置きvpc-endpointなどでつなげることも可能のはず。

setup inventory(create-association)はterraform(0.9.3)ではまだtargetの指定ができなくautoscaling groupでの適応が難しい。こちらはマネジメントコンソールから手動で行う必要がある。


## setup inventory
 Managed Instances -> Setup Inventory
![setup inventory](./setupinventory.png)

 Manged Instances -> Select Instance -> Inventory tab -> Inventory Type -> AWS:Application
![ssm inventory](./ssm_inventory.png)



## Run Command

```bash
aws ssm send-command --document-name "AWS-RunShellScript" \
--parameters commands=['echo helloWorld'] \
--targets "Key=tag:aws:autoscaling:groupName,Values=my-env-test-asg-008666db744cb8c5b52fa45377"
```

```json
{
    "Command": {
        "Comment": "",
        "Status": "Pending",
        "MaxErrors": "0",
        "Parameters": {
            "commands": [
                "echo helloWorld"
            ]
        },
        "ExpiresAfter": 1493618688.499,
        "ServiceRole": "",
        "DocumentName": "AWS-RunShellScript",
        "TargetCount": 0,
        "OutputS3BucketName": "",
        "NotificationConfig": {
            "NotificationArn": "",
            "NotificationEvents": [],
            "NotificationType": ""
        },
        "CompletedCount": 0,
        "Targets": [
            {
                "Values": [
                    "my-env-test-asg-008666db744cb8c5b52fa45377"
                ],
                "Key": "tag:aws:autoscaling:groupName"
            }
        ],
        "StatusDetails": "Pending",
        "ErrorCount": 0,
        "OutputS3KeyPrefix": "",
        "RequestedDateTime": 1493611488.499,
        "CommandId": "2688a2d5-cbc7-40da-a1f7-37e045036195",
        "InstanceIds": [],
        "MaxConcurrency": "50"
    }
}
```
