# ec-cube-ec2-infra

## これは何

New Relic 検証用環境



#### EC2のキーペア
EC2にsshログインする場合には予め秘密鍵を作っておく必要があるので、[Amazon EC2 キーペアと Linux インスタンス](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-key-pairs.html)を参考にしてキーペアを作成しておくこと。
作成する際のKey名は `infra-study` とする。
※後続手順でterraform applyする際にCLI上から入力を求められる。

#### インバウンドアクセス制限
起動したEC2に対してアクセス制限を行うため、[What Is My IP Address](https://whatismyipaddress.com/)などを参考に、現在インターネットにアクセスしているIPを特定する（terraform applyの際にCLI上で入力する）。

デフォルトでは外部からはアクセスできない仕様であるため、かならず何らかのIPを指定する必要がある。


### 2-3-3. リソースを構築

apply後にAWSコンソールを見て、applyしたリソースが追加されていることを確認する。

```shell
$ ec2_name=infra-study
$ instance_id=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$ec2_name" \
  | jq -r ".Reservations[0].Instances[0].InstanceId")

# EC2に繋ぐ
$ aws ssm start-session --target $instance_id
```

SSM Session ManagerでEC2にsshログイン出来るようにするため、`~/.ssh/config` に以下の定義を記載する。
※詳細については[ステップ 8: (オプション) Session Manager を通して SSH 接続のアクセス許可を有効にして制御する](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)を参照のこと。

```config
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

以下を実行することでEC2にアクセスできることを確認する。

```shell
$ ec2_name=infra-study
$ instance_id=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$ec2_name" "Name=instance-state-name,Values=running" \
  | jq -r ".Reservations[0].Instances[0].InstanceId")

$ ssh -i ~/path/to/infra-study.pem ec2-user@"$instance_id"
Last login: Sun Jan 29 11:55:11 2023 from localhost

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-0-1-2-345 ~]$
```
