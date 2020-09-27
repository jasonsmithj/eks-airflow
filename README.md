## Secretの暗号化について
### 概要
AWS Parameter Storeに相当するDB PasswordやAPI Tokenを保存する
Kubernetesの仕組みにSecret機能があります。

Secret機能はYAMLファイルで定義することができますが、そのままGit管理してしまうと
機密情報がGithubに晒されてしまいます。

そこでAWS KMSを使用した暗号化を行って暗号化済みのファイルをGit管理していきます。
使用するToolはmozillaが作成しているOSSである[SOPS](https://github.com/mozilla/sops#yaml-and-json-type-extensions)です。

※ [kubernetes-external-secrets](https://github.com/godaddy/kubernetes-external-secrets)を使用してもいいかもしれないですね。

### install
python3が必要です
```bash
pip install sops
```

### AWS KMSのkeyを指定
```bash
export SOPS_KMS_ARN="arn:aws:kms:ap-northeast-1:<your aws account id>:key/<your kms key>
```

### 暗号化ファイルの編集
valueに記載する値はbase64したものを設定してください。
Kubernetesの仕様です。
```bash
sops secret.sops.yaml
```

### 変更したファイルをeksにセットする方法
```bash
sops -d secret.sops.yaml | kubectl apply -f -
```
