#!/usr/bin/env bash
# install.sh
# zsh / bash に `init-rules` 関数を登録するインストーラ（Mac / Linux 用）。
# 新しいMacでは次の一行を実行するだけ:
#   curl -fsSL https://raw.githubusercontent.com/masaishi82/ai-project-template/main/install.sh | bash

set -euo pipefail

# ---- 設定 -------------------------------------------------------------
REPO_OWNER="masaishi82"
REPO_NAME="ai-project-template"
BRANCH="main"
RULES_FILE="AI_PROJECT_RULES.md"
# ---------------------------------------------------------------------

RAW_BASE="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"
URL="${RAW_BASE}/${RULES_FILE}"

START_MARKER="# >>> ai-project-template (init-rules) >>>"
END_MARKER="# <<< ai-project-template (init-rules) <<<"

# ログインシェルに応じて rc ファイルを決定
case "${SHELL:-}" in
  *zsh)  RC="${ZDOTDIR:-$HOME}/.zshrc" ;;
  *bash) RC="$HOME/.bashrc" ;;
  *)     RC="${ZDOTDIR:-$HOME}/.zshrc" ;;   # Mac 既定は zsh
esac
touch "$RC"

# 既存の同ブロックを除去（再実行で重複しないように）
tmp="$(mktemp)"
awk -v s="$START_MARKER" -v e="$END_MARKER" '
  $0==s {skip=1}
  skip==0 {print}
  $0==e {skip=0}
' "$RC" > "$tmp"
mv "$tmp" "$RC"

# 関数ブロックを追記（URL はリテラルで埋め込む）
cat >> "$RC" <<EOF

${START_MARKER}
init-rules() {
  local path="."
  local force=0
  for arg in "\$@"; do
    case "\$arg" in
      -f|--force) force=1 ;;
      *) path="\$arg" ;;
    esac
  done
  local dest="\${path}/${RULES_FILE}"
  if [ -e "\$dest" ] && [ "\$force" -ne 1 ]; then
    echo "warning: \$dest は既に存在します。上書きは -f を付けてください。" >&2
    return 1
  fi
  if curl -fsSL "${URL}" -o "\$dest"; then
    echo "✓ ${RULES_FILE} を配置しました: \$dest"
  fi
}
${END_MARKER}
EOF

echo ""
echo "✓ init-rules を登録しました: $RC"
echo "  新しいターミナルを開くか、次を実行してすぐ使えます:"
echo "    source \"$RC\""
echo ""
echo "使い方:"
echo "    init-rules        # カレントフォルダに ${RULES_FILE} を配置"
echo "    init-rules -f     # 既存ファイルを上書き"
