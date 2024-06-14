# GAUDINodeRED

## 目次
* [概要](#概要)
* [機能](#機能)
* [Quick Start](#quick-start)
* [ノードモジュール一覧](#ノードモジュール一覧)
* [Pythonパッケージ一覧](#pythonパッケージ一覧)
* [イメージのURL](#イメージのurl)
* [動作保証環境](#動作保証環境)
* [Deployment 設定値](#deployment-設定値)
  * [環境変数](#環境変数)
  * [Desired Properties](#desired-properties)
  * [Create Option](#create-option)
* [受信メッセージ](#受信メッセージ)
* [送信メッセージ](#送信メッセージ)
* [NodeREDにおけるメッセージの扱い](#noderedにおけるメッセージの扱い)
* [Direct Method](#direct-method)
* [NodeREDの機能](#noderedの機能)
  * [フロー停止機能](#フロー停止機能)
  * [ユーザー管理機能](#ユーザー管理機能)
* [LocalACR連携機能](#localacr連携機能)
  * [ユーザー設定保存](#ユーザー設定保存)
  * [ユーザー設定復元](#ユーザー設定復元)
* [ユースケース](#ユースケース)
* [Feedback](#Feedback)
* [LICENSE](#LICENSE)

## 概要
GAUDINodeREDは、カスタムノードを利用可能な Node-RED を展開します。


## 機能
カスタムノードを利用可能な Node-RED を展開する。

## Quick Start
鋭意製作中

## イメージのURL
準備中

| URL                                                                     | Description          |
| ----------------------------------------------------------------------- | -------------------- |

## ノードモジュール一覧

含まれるノードモジュールは以下の通り。

| ノードモジュール名                  | 機能概要                       | バージョン | リンク |
| --------------------------------- | ------------------------------ | ---------- | ------ |
| node-red-blobstorage   　　　　　　| BlogStorage へのアクセス機能   | 1.1.0      | ...    |
| node-red-iotedge       　　　　　　| iotedge 入出力機能             | 1.2.0      | ...    |
| node-red-kv            　　　　　　| Keyence レジストリアクセス機能 | 1.1.0      | ...    |
| node-red-python        　　　　　　| Python コード実行機能          | 1.0.0      | ...    |
| node-red-datacleansing 　　　　　　| データクレンジング機能         | 1.0.2      | ...    |
| node-red-contrib-omron-fins       | オムロンPLCとの通信機能     | 0.5.0      | [node-red-contrib-omron-fins](https://flows.nodered.org/node/node-red-contrib-omron-fins)    |
| node-red-contrib-mcprotocol       | MITSUBISHI PLCとの通信機能 | 1.2.1      | [node-red-contrib-mcprotocol](https://flows.nodered.org/node/node-red-contrib-mcprotocol)    |
| node-red-contrib-python3-function | Python コード実行機能      | 0.0.4      | [node-red-contrib-python3-function](https://flows.nodered.org/node/node-red-contrib-python3-function)    |

## Pythonパッケージ一覧

含まれるPythonパッケージは以下の通り(依存関係パッケージは表記しない)。

| パッケージ名         | 機能概要                                | バージョン |
| ------------------- | -------------------------------------- | ---------- |
| wheel               | パッケージ管理                          | 0.40.0      |
| azure-storage-blob  | Azure blob Storageクライアントライブラリ | 12.14.1    |
| pandas              | データ解析機能提供ライブラリ              | 2.0.3  |


## 動作保証環境

| Module Version | IoTEdge | edgeAgent | edgeHub  | amd64 verified on | arm64v8 verified on | arm32v7 verified on |
| -------------- | ------- | --------- | -------- | ----------------- | ------------------- | ------------------- |
| 5.0.0      | 1.4.3   | 1.4.4     | 1.4.4    | ubuntu20.04       | －                  | －                  |

## Deployment 設定値

### 環境変数

#### 環境変数の値

| Key                         | Required | Default       | Description |
| ----                        | -------- | ------------- | ----------- |
| LogLevel                    |          | info          | 出力ログレベル。<br>["trace", "debug", "info", "warn", "error"] |
| EnableMetrics               |          | false         | メトリクス情報を出力するかのフラグ。<br>trueの場合、フロー実行(メッセージ単位)イベントとメモリ仕様情報(15秒おき)が出力される。<br>["true", "false"] |
| EnablePalette               |          | true          | パレットマネージャーを表示するかのフラグ。<br>["true", "fase"] |
| EnableFlowStop              |          | false         | フローを停止させる機能を有効にするかのフラグ。詳細は[フロー停止機能](#フロー停止機能)参照。<br>["true", "false"]<br><span style="color: red; ">(運用レベルでの利用不可)</span> |
| EnableUserLogin             |          | true          | ユーザー管理機能を有効にするかのフラグ。<br>詳細は[ユーザー管理機能](#ユーザー管理機能)参照。<br>["true", "false"] |
| AdminPassword               |          | adminP@ssw0rd | Adminユーザーのパスワード<br><span style="color: red; ">(設定推奨)</span> |
| GuestPassword               |          | guestP@ssw0rd | guestユーザーのパスワード |
| EditorRoot                  |          | /             | エディターにアクセスするためのURLに付与するパス(※)。<br>例："/admin"に設定すると、http://[IP]:[HostPort]/admin でエディターにアクセスすることができ、http://[IP]:[HostPort]/ でアクセスできなくなる。     |
| AzureIoTMaxOperationTimeout |          | 3600000       | EdgeHubとの接続やメッセージ送受信等の通信において再試行が行われた際のタイムアウト時間。単位はミリ秒。 |
| RetryErrorFilter            |          |               | <span style="color: red; ">トラブル回避用のため通常時は利用不可</span><br>EdgeHubとの切断時エラーの種類によって再接続の要否を判定する際に用いられるフィルタが存在する。この環境変数でそのフィルタに対し、エラーを新規追加もしくは判定の変更ができる。<br>現状既知のエラーは全て再接続処理に進むよう設定されている。<br>値は"エラー名=[true もしくは false]"の形で設定する。設定した値以外はデフォルト(再接続処理が行われる)から変更されない。<br>trueに設定した場合は、そのエラーにより切断された時再接続処理に入る。<br>falseに設定した場合は、そのエラーにより切断された時再接続処理が行われない。<br>複数指定したい場合は","で繋ぐ。<br>例："xxxxxError=true,TimeoutError=false"で設定した場合はxxxxErrorがフィルタに追加、TimeoutErrorがfalseに変更され、他のエラーはデフォルトのまま再接続処理される設定となる。 |

※URLに利用可能な文字のみ指定可能。それ以外の文字はURLエンコーディングが必要。<br>
&nbsp;&nbsp;参考) [URLエンコード対象の文字について](https://ja.wikipedia.org/wiki/%E3%83%91%E3%83%BC%E3%82%BB%E3%83%B3%E3%83%88%E3%82%A8%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%87%E3%82%A3%E3%83%B3%E3%82%B0)

### Desired Properties

ワークスペースのデプロイ内容による

### Create Option

#### Create Option の値

| JSON Key                    | Type    | Required | Description                                 |
| --------------------------- | ------- | -------- | ------------------------------------------- |
| HostConfig                  | object  | &nbsp;         | &nbsp;                                            |
| &nbsp; ~~Privileged~~       | ~~boolean~~| ~~○~~   | 使用不可<br>~~ホスト上の全デバイスへ接続可能にするか~~      |
| &nbsp; Binds                | array   | &nbsp;         | Node-RED の設定ファイル格納先をマウントする(※) |
| &nbsp; PortBindings         | object  | &nbsp;         | &nbsp;                                            |
| &nbsp;&nbsp; 1880/tcp       | array   | &nbsp;         | &nbsp;                                            |
| &nbsp;&nbsp;&nbsp; HostPort | string  |&nbsp;          | Node-RED エディタへの接続ポート番号の割当   |
| &nbsp; Devices              | array   | &nbsp;         | システムデバイスのバインド設定      |
| &nbsp; {}                   | object   | &nbsp;        | &nbsp;      |
| &nbsp; &nbsp; CgroupPermissions | string | 〇          | コンテナグループのパーミッション設定<br>　※"r","w","m" を組み合わせて指定する（例："rw"）<br> r: read, w: write, m: mknod     |
| &nbsp; &nbsp; PathInContainer | string | 〇            | コンテナ上のデバイスパス      |
| &nbsp; &nbsp; PathOnHost      | string | 〇            | ホスト上のデバイスパス      |



※注意事項<br>

- コンテナ内の"/data"ディレクトリをローカルにバインドすることを推奨する。<br>該当のフォルダをバインドしていない場合、コンテナ削除時などにフローや設定などの編集内容が消失してしまう

#### Create Option の記入例

```json
{
  "HostConfig": {
    "Privileged": true,
    "Binds": ["/node-red:/data"],
    "PortBindings": {
      "1880/tcp": [
        {
          "HostPort": "1880"
        }
      ]
    }
  }
}
```

## 受信メッセージ

- ModuleInputノードを通して他のモジュールからのメッセージ受信を行う
- メッセージのBody, Propertyがmsgオブジェクトに格納される。
- メッセージの内容については[NodeREDにおけるメッセージの扱い](#noderedにおけるメッセージの扱い)を参照
- ModuleInputノードでメッセージ受信時にPropertyとして下記の情報が追加される
  - $.cdidプロパティ(properties配下): 送信元デバイス名
  - $.cmidプロパティ(properties配下): 送信元モジュール名


## 送信メッセージ

- ModuleOutputノードから他のモジュールへのメッセージ送信を行う
- メッセージの内容については[NodeREDにおけるメッセージの扱い](#noderedにおけるメッセージの扱い)を参照
- ModuleOutputノードでメッセージ送信時に下記の操作を行う
  - countメソッド(properties配下): 追加
  - $.cdidプロパティ(properties配下): 削除
  - $.cmidプロパティ(properties配下): 削除


## NodeREDにおけるメッセージの扱い

- NodeRED上ではメッセージはjavascriptベースのmsgオブジェクトで入出力される
- 基本的にはmsg.payloadが主な入出力値の格納先になる
- 他のモジュールからのメッセージ受信はModuleInputノード,<br>モジュールへのメッセージ送信はModuleOutputノードを使用する
  - 送受信時のデータ構成は下記のようになっている

    | JSON Key            | Type   | Description                  |
    | ------------------- | ------ | ---------------------------- |
    | payload             | any    | メッセージの Body 相当       |
    | properties          | object | メッセージの Property 格納先 |
    | &nbsp; propertyList | array  | メッセージの Property 相当   |
    | &nbsp; &nbsp; key   | string | プロパティ名                 |
    | &nbsp; &nbsp; value | string | プロパティの値               |

    ```json
    {
      "payload": {
        "RecordList": [
          {
            "RecordHeader": ["sample.csv"],
            "RecordData": ["A1", "B1", "C1", "D1", "E1"]
          }
        ]
      },
      "properties": {
        "propertyList": [
          { "key": "filename", "value": "sample.csv" },
          { "key": "row_number", "value": "1" },
          { "key": "row_total", "value": "5" },
          { "key": "$.cdid", "value": "topLayerDevice" },
          { "key": "$.cmid", "value": "csvfilereceiver01" }
        ]
      }
    }
    ```


## Direct Method

ModuleMethodノードを起点にダイレクトメソッドを実装する。

## NodeREDの機能

環境変数で有効/無効を設定できる機能について説明する。

### フロー停止機能

環境変数の「EnableFlowStop」をtrueに設定することで有効になる。<br>
有効にした場合、デプロイボタン横の▽から開けるリストに「停止」が含まれるようになる。<br>
一度「停止」を押すと、そのボタンは「開始」に切り替わる。<br>

![nodered_flowstop](./docs/img/flowstop_button.png)![nodered_flowstart](./docs/img/flowstart_button.png)

フローが停止した状態でも、ノードの編集・デプロイは可能になっている。<br>
また、"/data"フォルダのバインドを行っている場合はコンテナの再起動・削除を行っても停止・開始状態は保持され続ける。

### ユーザー管理機能

環境変数の「EnableUserLogin」をtrueに設定することで有効になる。<br>
有効にした場合、エディタを開く際にログイン操作が必要になる。<br>

![nodered_loginform](./docs/img/nodered_loginform.png)

<br>本システムでは、以下のユーザが利用可能。

| ユーザ名 |パスワード                                       | 使用不可機能                       |
| ------- | ---------------------------------------------- | --------------------------------- |
| admin   | adminP@ssw0rd or 環境変数「AdminPassword」で設定 | 無し                              |
| guest   | guestP@ssw0rd or 環境変数「GuestPassword」で設定 | デプロイ・設定・パレットマネージャー |

## LocalACR連携機能

LocalACR連携機能により、ユーザー設定(デプロイしたフロー、追加したノード)を保存し、イメージとして復元を可能にする。
本機能の利用には、コンテナ内の/dataフォルダのバインドが必要。

### ユーザー設定保存

実行時のバインドフォルダ配下を、ユーザ設定データとして起動中のNodeREDのコンテナ内に保存する。
本機能は、NodeREDが起動中のデバイス上でLocalACR登録の前処理シェル(※)を介して実行する。
この時、コンテナ内にユーザー設定が保存済み場合は、上書きする。

※ 詳細はLocalACRの構築手順書を参照

### ユーザー設定復元
バインドフォルダが空の場合のみ、NodeRED起動時にイメージ内に保存されているユーザー設定データをバインドフォルダにコピーする。
これにより、ユーザ設定が復元された状態のNodeREDが起動する。
バインドフォルダが空でない場合は、復元を行わない。

## ユースケース

基本ノードや各カスタムノードのサンプルフローは、メニューの「読み込み」から挿入することが可能なため、そちらを参照
![usecase_reference](./docs/img/usecase_reference.png)

## Feedback
お気づきの点があれば、ぜひIssueにてお知らせください。

## LICENSE
GAUDINodeRED is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.
