# Minecraft-Server

## 目的

マイクラサーバーを立ち上げて遊ぶこと、Linux やクラウドの知識を身に着けること

## 使用できるクラウド

- AWS(alltimes)
- GCP(3 months)
- Azure(1 year)

## 利用者の認証方法

- ユーザー ID と IP アドレス

## 管理用 docker コンテナの実装

### 機能

- terraform、ansible を使ったサーバーの構築
- Nukkit のインストール、ファイルの作成をする
- Nukkit のアップデートを本番環境に反映させる
- ssh を使用して AWS の EC2 に直接アクセスし、操作する
- 本版環境のログを何かしらの方法で取り込む
- Vault

### Nukkit を使う？使わない？

> A. 使わない

#### 理由

Nukkit が持つ機能を自分でシェルスクリプトなどを使って実装したほうが勉強になるから
