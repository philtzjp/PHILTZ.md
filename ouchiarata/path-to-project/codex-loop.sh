#!/bin/bash
# クラッシュ耐性のあるウォッチドッグ型ループ
set -u
set -o pipefail

round_number=1

while true; do
    echo "=== ラウンド ${round_number} ==="

    codex exec --dangerously-bypass-approvals-and-sandbox \
        "前回の作業を確認し、ワークツリーがクリーンではない場合コミットを行い、クリーンなワークツリーで次の未完了タスクに取り組んでください" \
        2>&1 | tee "/tmp/codex_log_${round_number}.txt"

    exit_code=${PIPESTATUS[0]}

    if [ "${exit_code}" -ne 0 ]; then
        echo "エラー発生 (exit=${exit_code})、10秒後にリトライ..."
        sleep 10
    else
        sleep 3
    fi

    round_number=$((round_number + 1))
done
