# ai-project-template

プロジェクト開始時に置く `AI_PROJECT_RULES.md` のマスターと、それを配置するためのインストーラです。
PCが変わっても、このリポジトリ経由でいつでも最新のルールファイルを取得できます。

> ⚠️ このリポジトリは公開（Public）です。社内固有の情報・機密・個人情報は書き込まないでください。

## 新しいPCでのセットアップ（一行）

### Windows（PowerShell）

```powershell
irm https://raw.githubusercontent.com/masaishi82/ai-project-template/main/install.ps1 | iex
```

### Mac / Linux（zsh・bash）

```bash
curl -fsSL https://raw.githubusercontent.com/masaishi82/ai-project-template/main/install.sh | bash
```

どちらも `init-rules` コマンドがシェルに登録されます（Windows は PowerShell プロファイル、Mac/Linux は `~/.zshrc` または `~/.bashrc`）。

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
| `install.ps1` | Windows（PowerShell）用インストーラ |
| `install.sh` | Mac / Linux（zsh・bash）用インストーラ |

ルールを更新したいときは、このリポジトリの `AI_PROJECT_RULES.md` を編集して push するだけ。
以後 `init-rules` は常に最新版を取得します。
