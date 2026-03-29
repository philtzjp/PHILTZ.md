#!/bin/bash
# runner.sh — 自走Claude (Runner)
# claude -p をシェルループで回す自走エージェント

set -euo pipefail

WORKDIR="$(pwd)"
BRIDGE_DIR="$WORKDIR/.bridge"
mkdir -p "$BRIDGE_DIR"

# ── 色定義 ──
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_DIM="\033[2m"
C_CYAN="\033[36m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_MAGENTA="\033[35m"
C_BLUE="\033[34m"

# ── ストリーム整形関数 ──
format_stream() {
    local full_text=""
    local in_tool=false
    local current_tool=""
    local tool_input=""
    local last_was_tool=false

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue

        if ! command -v jq &>/dev/null; then
            echo "$line"
            continue
        fi

        local msg_type
        msg_type=$(echo "$line" | jq -r '.type // empty' 2>/dev/null) || continue

        case "$msg_type" in
            assistant)
                local content
                content=$(echo "$line" | jq -r '
                    [.message.content[]? | select(.type == "text") | .text] | join("")
                ' 2>/dev/null) || true
                if [[ -n "$content" ]]; then
                    full_text+="$content"
                    if [[ "$last_was_tool" == true ]]; then
                        echo -ne "\n" >&2
                        last_was_tool=false
                    fi
                    echo -ne "${C_RESET}${content}" >&2
                fi
                ;;
            content_block_start)
                local block_type
                block_type=$(echo "$line" | jq -r '.content_block.type // empty' 2>/dev/null)
                if [[ "$block_type" == "tool_use" ]]; then
                    in_tool=true
                    current_tool=$(echo "$line" | jq -r '.content_block.name // "tool"' 2>/dev/null)
                    tool_input=""
                fi
                ;;
            content_block_delta)
                local delta_type
                delta_type=$(echo "$line" | jq -r '.delta.type // empty' 2>/dev/null)
                if [[ "$delta_type" == "text_delta" ]]; then
                    local text
                    text=$(echo "$line" | jq -r '.delta.text // empty' 2>/dev/null)
                    if [[ -n "$text" ]]; then
                        full_text+="$text"
                        if [[ "$last_was_tool" == true ]]; then
                            echo -ne "\n" >&2
                            last_was_tool=false
                        fi
                        echo -ne "${C_RESET}${text}" >&2
                    fi
                elif [[ "$delta_type" == "input_json_delta" ]]; then
                    local partial
                    partial=$(echo "$line" | jq -r '.delta.partial_json // empty' 2>/dev/null)
                    tool_input+="$partial"
                fi
                ;;
            content_block_stop)
                if [[ "$in_tool" == true ]]; then
                    local summary=""
                    if [[ -n "$tool_input" ]]; then
                        case "$current_tool" in
                            Read|Write|Edit)
                                summary=$(echo "$tool_input" | jq -r '.file_path // empty' 2>/dev/null)
                                summary="${summary#"$WORKDIR"/}"
                                ;;
                            Bash)
                                summary=$(echo "$tool_input" | jq -r '.command // empty' 2>/dev/null)
                                [[ ${#summary} -gt 60 ]] && summary="${summary:0:57}..."
                                ;;
                            Glob|Grep)
                                summary=$(echo "$tool_input" | jq -r '.pattern // empty' 2>/dev/null)
                                ;;
                            *)
                                summary=""
                                ;;
                        esac
                    fi
                    printf "  ${C_DIM}${C_CYAN}%-6s${C_RESET} ${C_DIM}%s${C_RESET} ${C_GREEN}✓${C_RESET}\n" "$current_tool" "$summary" >&2
                    in_tool=false
                    tool_input=""
                    last_was_tool=true
                fi
                ;;
            result)
                local result_text
                result_text=$(echo "$line" | jq -r '
                    if .result then .result
                    elif .message.content then
                        [.message.content[]? | select(.type == "text") | .text] | join("\n")
                    else empty end
                ' 2>/dev/null) || true
                if [[ -n "$result_text" ]]; then
                    full_text="$result_text"
                fi
                ;;
        esac
    done

    echo -ne "\n" >&2
    echo "$full_text"
}

# 初期化 — PLAN.md を指示として使う
PLAN_FILE="$WORKDIR/PLAN.md"
if [[ ! -s "$PLAN_FILE" ]]; then
    echo -e "${C_YELLOW}[Runner] PLAN.md が見つからないか空です。作成してから再実行してください。${C_RESET}"
    exit 1
fi
echo -e "${C_GREEN}[Runner] PLAN.md を読み込み、開始${C_RESET}"

ITERATION=0

while true; do
    ITERATION=$((ITERATION + 1))

    PLAN=$(cat "$PLAN_FILE")
    CLAUDE_MD=$(cat "$WORKDIR/CLAUDE.md" 2>/dev/null || echo "")

    PROMPT=$(cat <<EOF
あなたは自走コーディングエージェントです。イテレーション #${ITERATION}。

## プロジェクトルール（厳守）
${CLAUDE_MD}

## 計画（PLAN.md）
${PLAN}

## ルール
1. PLAN.md に従ってタスクを1ステップ進めろ
2. 完了したタスクは PLAN.md 内で直接 [x] に更新しろ
3. PLAN.md の全タスクが完了したら「DONE」と出力しろ
4. コミット前に必ず npx tsc --noEmit を実行し、TypeScript コンパイルが通ることを確認しろ。通らなければ修正してから進め
5. 毎イテレーション完了時に git add && git commit しろ（コミットメッセージは CLAUDE.md のフォーマットに従え）
6. コミット後に git push しろ
7. 機能追加・変更時は VERSION を更新し llm/version/{version}.md を作成しろ
8. アーキテクチャに変更があれば llm/ARCHITECTURE.md を更新しろ
EOF
    )

    echo -e "\n${C_BOLD}${C_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "${C_BOLD}${C_CYAN}[Runner]${C_RESET} イテレーション ${C_BOLD}#${ITERATION}${C_RESET} 開始"
    echo -e "${C_BOLD}${C_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"

    OUTPUT=$(claude -p --dangerously-skip-permissions "$PROMPT" \
        --verbose \
        --output-format stream-json \
        --allowedTools "Bash,Read,Write,Edit,Glob,Grep" \
        2>"$BRIDGE_DIR/stderr.log" \
        | format_stream) || true

    echo -e "${C_DIM}${C_GREEN}[Runner]${C_RESET} イテレーション #${ITERATION} 完了"

    if echo "$OUTPUT" | grep -q "DONE"; then
        echo -e "\n${C_BOLD}${C_GREEN}[Runner] ✓ 全タスク完了${C_RESET}"
        break
    fi

    if grep -q "PAUSE" "$PLAN_FILE"; then
        echo -e "${C_YELLOW}[Runner] 一時停止中... PLAN.md から PAUSE を消すと再開${C_RESET}"
        while grep -q "PAUSE" "$PLAN_FILE"; do
            sleep 2
        done
        echo -e "${C_GREEN}[Runner] 再開${C_RESET}"
    fi

    sleep 1
done
