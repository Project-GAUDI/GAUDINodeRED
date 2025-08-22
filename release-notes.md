# GAUDINodeRED Release Notes
## 6.1.6
* 脆弱性対応
  * form-data最新化(4.0.4)
  * multer最新化(2.0.2)

## 6.1.5

* 動作保証バージョン更新
  * IoTEdge : 1.5.21
  * edgeAgent: 1.5.21
  * edgeHub : 1.5.21
* 脆弱性対応
  * requests最新化(再ビルド)
  * lrb5最新化(再ビルド)
  * multer最新化

## 6.1.4

* 脆弱性対応
  * 脆弱性があるdevDependenciesライブラリ削除
  * node-red-admin最新化

## 6.1.3

* 脆弱性対応
  * Node-REDベースイメージのバージョンアップ(3.1.15)
  * Node.jsベースイメージのバージョンアップ(node:18.20.7-slim)

## 6.1.2

* "Node-RED-IoTEdge"更新(6.0.2)
  * 環境変数AzureIoTMaxOperationTimeoutを小さい値にするとノード初期化に失敗する不具合修正
    * AzureIoTMaxOperationTimeoutの下限を設定(240000ミリ秒)
* "Node-RED-DataCleansing"更新(6.0.2,6.0.3)
  * data-cleansingノードの不具合対応
    * 変換結果の出力先がpayload固定となる不具合を修正
    * 入力メッセージの形式にGAUDI標準を選択した際に、RecordHeaderまたはRecordDataのいずれか、もしくは両方が無い場合に動作しない不具合を修正
    * エラーログ出力の一部不具合を修正

## 6.1.1

* azure-blob-storage(1.4.4)との互換性不具合対応
  * azure-storage-blobのバージョン変更(12.15.0)

* 脆弱性対応
  * 脆弱性があるdevDependenciesライブラリ削除

## 6.1.0

* 脆弱性対応
  * Node-REDベースイメージのバージョンアップ(3.1.12)
  * コンテナベースイメージの最新化(18.20.4)
  * 一部参照ライブラリの最新化
  * setuptools最新化
  * ipライブラリ除外(npmの最新化)
  * 脆弱性があるdevDependenciesライブラリ削除

* https対応
  * https対応環境変数追加
  * 証明書入力用環境変数追加

* Settings.js直接指定対応
  * 開発・検証用として、Settings.jsの直接指定環境変数を追加

* healthcheck対応
  * healthcheck.jsの不備で、dockerのステータスが（unhealthy）となっている問題を修正

## 6.0.1

* pythonツールおよびライブラリの依存関係不具合修正
  * pythonツール関係更新
    - python3=3.11.2-1+b1
    - python-is-python3=3.11.2-1+deb12u1
    - python3-pip=23.0.1+dfsg-1
  * pythonライブラリ関係更新
    - wheel==0.44.0
    - azure-storage-blob==12.23.0
    - pandas==2.2.2

## 6.0.0

* Dockerイメージベースから、オリジナルのNodeREDソースベースに変更
* ログの出力フォーマット変更
* TemplateDR-DXPlatformArea 6.0.0の反映
  * spec.md修正
  * パイプライン修正
  * IoTEdge1.5対応
  * ubuntu-22.04対応
* 個別パイプライン修正
  * 使用Feed選択可能化
  * ノードパッケージバージョン選択可能化
  * Azure SDKの取り込み方法を変更
  * ノードパッケージ取り込み方法を変更(npm install使用)
  * パイプライン実行中シェルでエラー発生時に異常終了するよう修正
* "Node-RED-IoTEdge"更新(6.0.1)
  * GAUDIコンテナのログ出力のポリシー変更対応
  * IoTEdgeノードの接続タイムアウト値をSDKに合わせるように変更
  * 送信メッセージにcontentTypeとcontentEncodingを付与するように変更

## 5.2.0

* "Node-RED-IoTEdge"更新(2.0.0)
  * メッセージ送受信のAmqp対応
* "Node-RED-IoTEdge"更新(2.1.0)
  * Amqp時のみ発生するcomplete処理不具合対応
    * complete処理タイミングをinput名判定後に変更
    * ModuleInputデプロイ時input名の重複チェックを追加
  * $.cmid・$.cdidの重複回避対応
  * 送受信リトライ対象エラーから以下を除外
    * MessageTooLargeError
    * DeviceMessageLockLostError
* pipelineビルド時にpipでエラーになる問題の暫定対応
* Tagビルド時重複実行部分削除

## 5.1.0

* "Node-RED-DataCleansing"更新(2.0.0)
  * ログ出力標準化対応
  * SetFormatInfoノードをグローバル設定ノード化
  * data-cleansingノードにフォーマットIDとフォーマット情報の設定機能追加
  * data-cleansingノードに変換エラー処理のオプション追加
  * data-cleansingノードに新規変換関数の追加、修正
* pipelineビルド時にpipでエラーになる問題の暫定対応

## 5.0.1

* TemplateDR-DXPlatformArea 5.0.0の反映

## 5.0.0

* LocalACR連携機能の追加

## 5.0.0-rc1

* Node-REDベースイメージのバージョンアップ(3.0.2)
  * 取得先Artifactsをビルドの種類(手動/Tag)によって変更
  * ノードモジュール追加(node-red-contrib-omron-fins、node-red-contrib-mcprotocol、node-red-contrib-python3-function)
  * Pythonパッケージ削除(SoundFile、PyWavelets、matplotlib)、新規追加(azure-storage-blob、pandas)
* ネットワークが一定期間切断された後、ネットワークが復旧してもModuleInputにおいてメッセージが受信できなくなる不具合修正
  * "Node-RED-IoTEdge"更新(1.3.0)
    * タイムアウト時間デフォルト値変更・カスタム化対応
    * 通信エラーフィルターデフォルト値変更・カスタム化対応
    * 通信切断時ログ出力対応
  * "azure-iot-device"を元にカスタムパッケージ"gaudi-iot-device"作成(1.0.0)
    * タイムアウト時間を設定できるメソッド追加
    * 再接続不要判定時、再接続失敗時の発行イベント追加
* ログやエディターに関する設定、ユーザー管理機能を追加・環境変数化対応
* "Node-RED-DataCleansing"更新(1.0.3)
  * data-cleansingノードにおいて入力メッセージの形式に配列を選択した際に、必ずエラーが発生する潜在不具合を修正
  * data-cleansingノードにおいてfs.rmdirSync関数のrecursiveオプションが非推奨となり将来的に削除されるため、fs.rmSyncに変更
  * アイコンを変更
* "Node-RED-BlobStorage"更新(1.1.1)
  * APIバージョンによるエラー暫定対応としてSDKのバージョンを12.13.0に固定
  * settings.jsの扱い変更による対応としてupload-settingsノードをflows.jsonのみをアップロードするupload-flowsノードに変更

## 1.7.4

* "Node-RED-IoTEdge"更新(1.2.0)
  * ModuleInputを再作成または更新し「変更したフロー」「変更したノード」でデプロイした際にメッセージが多重に受信する不具合修正

## 1.7.3

* Stable STEP1対応

  以下の環境で動作保証
  * IoTEdge  : 1.4.3
  * edgeAgent: 1.4.4
  * edgeHub  : 1.4.4

## 1.7.3

* spec.mdの目次・見出し修正

## 1.7.2

* TemplateDR-DXPlatformArea 4.2.0の反映

## 1.7.1

* Module Outputノードに文字列以外のプロパティを含むメッセージを入力するとエラー発生対応
* ModuleInputで付与したプロパティ($.cdid, $.cmid)をModuleOutput処理時に削除する処理を再対応（修正不具合対応）

## 1.7.0

* slug対応
* TDD構成
* 内部構成変更

## 1.6.1

* data-cleansingノード不具合対応
  * フォーマット情報サイズが一定量を超えると実行時エラーが発生する不具合を修正。

## 1.6.0

* "Node-RED-IoTEdge"更新(1.1.0)
  * 修正 ("Module Output"ノード)

## 1.5.0

* "Node-RED-DataCleansing"追加
  * 追加 ("get-format-number"ノード)
  * 追加 ("set-format-info"ノード)
  * 追加 ("data-cleansing"ノード)

## 1.4.0

* "Node-RED-BlobStorage"更新
  * 修正 ("upload-settings"ノード)
  * 追加 ("upload-files"ノード)

## 1.3.0

* 下記Pythonライブラリを同梱 (AMD64のみ)
  | Name       | Version      |
  | ---------- | ------------ |
  | matplotlib | 3.4.3        |
  | numpy      | 1.21.2       |
  | PyWavelets | 1.1.1        |
  | SoundFile  | 0.10.3.post1 |

## 1.2.0

* パレット削除

## 1.1.0

* "Node-RED-KV"更新
  * 追加 ("kv-write-multiple"ノード)

## 1.0.0

* 新規作成
