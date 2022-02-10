## コミットごとにコミット情報一覧出力
Gitコミット一覧ファイルからコミット一覧を読み込んで
指定されたGitから歴史コミット情報を取得しながらファイルの形に出力すること。
- コミット提出者
- 日時
- コミット内容
- コミットID
- ソースファイル

>使用例：
```powershell
.\getGitCommitInfo.ps1 logfilename
```
Or
```powershell
.\getGitCommitInfo.ps1 
```

## 改修ソースを拾う
Gitバージョンのコミットを指定して、対象ソースをフォルダー階層を維持しながら拾う。

>使用例：
```powershell
.\pickupGitFiles.ps1 <SHA>
```

## ツールインストール方法
### 依頼
[PSYaml](https://github.com/Phil-Factor/PSYaml)

### 予想フォルダー
```
ツールフォルダー
│  commits.txt
│  conf.yml
│  getGitCommitInfo.ps1
│  ReadMe.md
│
└─PSYaml-master
```