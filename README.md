# 概要
ADBコマンドのlogcatで、端末ログを取得するプロジェクトです。  
adb_install_usb.ps1をPowerShellで実行すると、プロジェクト直下のlogフォルダにログが格納されます。  
事前に、ADBコマンドの実行環境を構築を実施してください。

# 環境構築
1. 以下にURLを開き、[SDK Platform-Tools for Windows をダウンロード]を押下し、利用規約に同意し、Android SDK Platform-Toolsのダウンロードしてください。  
[https://developer.android.com/studio/releases/platform-tools?hl=ja](https://developer.android.com/studio/releases/platform-tools?hl=ja)

2. ダウンロードしたzipファルダを、本プロジェクト直下に,ファルダ名を「platform-tools」で解凍してください。  
※通常、ファルダ名は「platform-tools」で自動で生成されます。  
※別名で解凍された場合、ファルダ名を「platform-tools」に変更してください。

3. 「platform-tools_push_create.bat」を実行してください。  
4. Windowsメニューからコマンドプロンプトを起動し、"adb version"を実行して、バーションが表示されれば、環境構築は完了です。  
※表示されない場合、PCを再起動し、再確認してください。

# 使い方
## 事前準備
- ADBコマンドの使用環境が構築済みであること。
- PCと端末がUSB接続されていること。
- 端末のUSBデバッカ機能が有効であること。

## 手順
1. 本プロジェクトに格納されている"adb_get_logcat.ps1"をPowerShellで実行する。
2. リアルタイムでログを取得しつづけます。
3. 処理を完了させるには、「続行するには、Enter キーを押してください...」でEnterキーを押下してください。
4. 処理を完了すると、ログが格納されているフォルダが自動で表示されます。

## その他
ログが格納されているフォルダに、実行した端末情報を記録した"deviceInfo.json"ファイルが生成されます。