# install.ps1
# PowerShell プロファイルに `init-rules` 関数を登録するインストーラ。
# 新しいPCでは次の一行を実行するだけ:
#   irm https://raw.githubusercontent.com/masaishi82/ai-project-template/main/install.ps1 | iex

$ErrorActionPreference = 'Stop'

# ---- 設定 -------------------------------------------------------------
$RepoOwner  = 'masaishi82'
$RepoName   = 'ai-project-template'
$Branch     = 'main'
$RulesFile  = 'AI_PROJECT_RULES.md'
# ---------------------------------------------------------------------

$RawBase = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/$Branch"

$startMarker = '# >>> ai-project-template (init-rules) >>>'
$endMarker   = '# <<< ai-project-template (init-rules) <<<'

# プロファイルに書き込む関数定義
$block = @"
$startMarker
function init-rules {
    [CmdletBinding()]
    param(
        [string]`$Path = '.',
        [switch]`$Force
    )
    `$url  = '$RawBase/$RulesFile'
    `$dest = Join-Path (Resolve-Path `$Path) '$RulesFile'
    if ((Test-Path `$dest) -and -not `$Force) {
        Write-Warning "`$dest は既に存在します。上書きするには -Force を付けてください。"
        return
    }
    Invoke-RestMethod -Uri `$url -OutFile `$dest
    Write-Host "✓ $RulesFile を配置しました: `$dest" -ForegroundColor Green
}
$endMarker
"@

# プロファイルファイルを用意
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir  = Split-Path $profilePath -Parent
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
if (-not (Test-Path $profilePath)) { New-Item -ItemType File -Path $profilePath -Force | Out-Null }

# 既存の同ブロックを除去（再実行で重複しないように）
$content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($null -eq $content) { $content = '' }
$pattern = [regex]::Escape($startMarker) + '[\s\S]*?' + [regex]::Escape($endMarker)
$content = [regex]::Replace($content, $pattern, '').TrimEnd()

# 追記
$newContent = ($content + "`r`n`r`n" + $block).TrimStart()
Set-Content -Path $profilePath -Value $newContent -Encoding UTF8

Write-Host ""
Write-Host "✓ init-rules を登録しました: $profilePath" -ForegroundColor Green
Write-Host "  新しいターミナルを開くか、次を実行してすぐ使えます:" -ForegroundColor DarkGray
Write-Host "    . `$PROFILE.CurrentUserAllHosts" -ForegroundColor Cyan
Write-Host ""
Write-Host "使い方:" -ForegroundColor DarkGray
Write-Host "    init-rules          # カレントフォルダに $RulesFile を配置" -ForegroundColor Cyan
Write-Host "    init-rules -Force   # 既存ファイルを上書き" -ForegroundColor Cyan
