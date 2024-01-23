■ 概要
　ADBコマンドのlogcatで、端末ログを取得するプロジェクトです。
　adb_install_usb.ps1をPowerShellで実行すると、プロジェクト直下のlogフォルダにログが格納されます。
　事前に、ADBコマンドの実行環境を構築を実施してください。

■ 環境構築
　　1.以下にURLを開き、[SDK Platform-Tools for Windows をダウンロード]を押下し、利用規約に同意し、Android SDK Platform-Toolsのダウンロードしてください。
　　　https://developer.android.com/studio/releases/platform-tools?hl=ja

　　2.ダウンロードしたzipファルダを、本プロジェクト直下に,ファルダ名を「platform-tools」で解凍してください。
　　　※通常、ファルダ名は「platform-tools」で自動で生成されます。
　　　※別名で解凍された場合、ファルダ名を「platform-tools」に変更してください。

　　3.「platform-tools_push_create.bat」を実行してください。
　　4.Windowsメニューからコマンドプロンプトを起動し、"adb version"を実行して、バーションが表示されれば、環境構築は完了です。
　　
■ 使い方
　　[事前準備]
　　・ADBコマンドの使用環境が構築済みであること。
　　・PCと端末がUSB接続されていること。
　　・端末のUSBデバッカ機能が有効であること。
　　
　　[手順] 
　　1.Googleストリームで以下を開く。
　　　G:\共有ドライブ\MDMプロジェクト\04.検証Gr\09.倉庫\01.ノウハウ\02.AndroidOS\auto_adb_install
　　2.「adb_install_usb.bat」を開く。
　　3.「Complete」と表示されたら、処理は終了です。
　　4.任意のキーを押下すると、CMD画面が自動終了します。
　　
　　
