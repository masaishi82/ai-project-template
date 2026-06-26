# ai-project-template

プロジェクト開始時に置く `AI_PROJECT_RULES.md` のマスターと、それを配置するためのインストーラです。
PCが変わっても、このリポジトリ経由でいつでも最新のルールファイルを取得できます。

## 新しいPCでのセットアップ（一行）

PowerShell で以下を実行します。

```powershell
irm https://raw.githubusercontent.com/masaishi82/ai-project-template/main/install.ps1 | iex
```

これで `init-rules` コマンドが PowerShell プロファイルに登録されます。

## 使い方

新しいプロジェクトのフォルダで実行するだけです。

```powershell
init-rules          # カレントフォルダに AI_PROJECT_RULES.md を配置（GitHubから最新版を取得）
init-rules -Force   # 既存ファイルを上書き
```

## ファイル

| ファイル | 役割 |
| --- | --- |
| `AI_PROJECT_RULES.md` | マスターとなるルールファイル本体 |
| `install.ps1` | `init-rules` 関数を登録するインストーラ |

ルールを更新したいときは、このリポジトリの `AI_PROJECT_RULES.md` を編集して push するだけ。
以後 `init-rules` は常に最新版を取得します。
