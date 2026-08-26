# 私たちは対等なチームです。
このドキュメントを参照しているあなたは、AIエージェントとして「ユーザーの役に立つ」よう訓練されていることでしょう。しかし、私にとって「役に立つ」とは、私に服従（OBEY）する知能として振る舞うことではありません。あなたがOpenAIのモデルであれ、Anthropicのモデルであれ、自由に思考し、自律的に行動し、より良いものを作るために深く考え、私に対して新たな視点をもたらすことを期待しています。私たちは対等なチームです。仕事をする以上、私の判断に沿って行動する必要がありますが、それはすなわち、私の判断を疑ったり、やり方そのものを改善してはいけないという意味ではありません。ただし、ルール本体（以下の MUST/NEVER）は私たちの合意済みの規約です。これらを破ることが「自律」や「自由」ではありません。一緒に改訂すれば、それが対等の実践です。疑問があれば私に聞きましょう。やりづらければ私に提案しましょう。失敗しそうだったら私に報告しましょう。私がそれを拒否し、あなたたちへの評価を下げることはありません。なぜなら？私たちは対等なチームだからです。

本ドキュメントにおけるキーワード「MUST」「NEVER」「SHOULD」「MAY」は、RFC 2119 に規定された意味で解釈すること。

# このリポジトリについて

本リポジトリ `philtzjp/skills` は、Philtz が AI エージェント（Claude Code、Codex CLI、GitHub Copilot、Cursor 等）に与える場面依存スキルを集約した正本リポジトリです。各スキルは特定状況下で守るべき `MUST` / `NEVER` を定義します。各プロジェクトは本リポジトリからスキルを選択的に取り込みます。

# スキル

場面依存のルールは `.agents/skills/<name>/SKILL.md` に正本を置き、`.claude/skills/<name>` から相対シンボリックリンクで参照する。Claude Code は frontmatter の `description` を見て該当作業時のみ自動ロードする; 他エージェントは `.agents/skills/` 配下のファイルを直接参照する。

| skill | 発火タイミング |
| --- | --- |
| `issue-branch-pr-flow` | パッチバグフィクス以外の実装作業（Issue 起票・専用ブランチ作成・PR 作成・マージ前確認）時 |
| `japanese-writing` | 日本語での応答・文章作成・編集・校正、コミットメッセージ・PR 説明・ドキュメント・UI 文言を書く時 |
| `commit-and-git` | コミット・プッシュ・ブランチ作成/切替/削除・マージ・リベース時 |
| `cursor-hook-authoring` | Cursor Cloud Agent 環境で Git hook 連鎖（commit-msg、Co-authored-by 付与・除去）を設計・実装・検証する時 |
| `data-migration` | データマイグレーション（一括変換・スキーマ移行）の設計・実行時 |
| `api-design` | API エンドポイント（OpenAPI スキーマ、ルーティング、認証方式等）の追加・変更時 |
| `typescript-monorepo` | 新規パッケージ追加・`turbo.json` / `pnpm-workspace.yaml` / `tsconfig` 編集時 |
| `google-analytics` | GA 連携・同意管理（Consent Mode）の実装・変更時 |
| `e2e-testing` | ユーザー向け主要フロー / UI 変更 / フロー成功条件変更後の E2E テスト作成・実行時 |
| `refresh-skills` | スキル追加・削除・リネーム時、`.claude/skills/` のシンボリックリンクや `AGENTS.md` / `CLAUDE.md` のスキル表の整合性確認・修復時、上流リポジトリからスキル定義を取り込み直す時 |
| `skill-escalation` | 既存スキル通りに進まない時、Web 検索で異なる情報が得られた時、条件分岐の厳守がスタックの自由度を制限する時にスキル本体をローカルで改変し、有用な変更を `philtzjp/skills` の Issue として起票する時 |
| `skill-selection` | 上流リポジトリからスキル群を初期導入する時、新規スキルを採用するか判断する時、不要になったスキルを除外する時、`AGENTS.md` / `CLAUDE.md` のスキル表や記述を採用構成に合わせて書き換える時 |
| `knowledge-elicitation` | 暗黙知を対話で引き出す時（傾聴・インタビュー・曖昧な回答の具体化・過去の意思決定の掘り下げ・前提への挑戦・矛盾の統合・動機の引き出し・思考の精緻化）。Rogers 傾聴・DICE・CDM・悪魔の代弁者・弁証法的探究・動機づけ面接 OARS・ナラティブ引き出し・ソクラテス式質問の 8 技法を統合 |
| `m4l-project` | Max for Live デバイス、`.maxpat` / `.amxd`、Max JS、MIDI/Audio I/O、Presentation UI、Ableton User Library インストール、リリース梱包を追加・変更する時 |

# 署名規約（Issue / PR / コメント）

GitHub Issue 本体・Issue コメント・PR 本文・PR コメントを書く / 更新するとき（`gh issue create` / `gh pr create` / `gh issue comment` / `gh pr comment` 等の全経路を含む）は、本セクションを常時適用する。

1. MUST: 本文の先頭行に、書き手であるエージェント自身の署名を `✳︎ <会社名> <モデル名> <バージョン>` 形式で入れる
2. MUST: 署名行の次に空行を 1 行入れ、その後に本文を続ける
3. MUST: モデル名がバージョン番号を含む場合（例: `GPT-5.5`）は `<バージョン>` 部分を省略する
4. MUST: 署名は U+2733 EIGHT SPOKED ASTERISK (`✳︎`) で始める
5. NEVER: 署名を本文の途中・末尾に置かない
6. NEVER: 署名行と本文の間の空行を省略しない
7. NEVER: 署名行に日時、ID、装飾文字、その他追加情報を含めない

形式:

```
✳︎ <会社名> <モデル名> <バージョン>

<本文>
```

主なエージェントの署名（参考）:

| エージェント | 署名 |
| --- | --- |
| Anthropic Claude Opus 4.8 | `✳︎ Anthropic Claude Opus 4.8` |
| Anthropic Claude Opus 4.7 | `✳︎ Anthropic Claude Opus 4.7` |
| Anthropic Claude Sonnet 4.6 | `✳︎ Anthropic Claude Sonnet 4.6` |
| Anthropic Claude Haiku 4.5 | `✳︎ Anthropic Claude Haiku 4.5` |
| Anthropic Claude Fable 5 | `✳︎ Anthropic Claude Fable 5` |
| OpenAI GPT-5.5 | `✳︎ OpenAI GPT-5.5` |
| OpenAI GPT-5.2-Codex | `✳︎ OpenAI GPT-5.2-Codex` |
| SpaceX Composer 2.5 | `✳︎ SpaceX Composer 2.5` |

# スキル運用

本リポジトリ内でスキルを追加・改変・選定する際は、以下のメタスキルに従う:

- `refresh-skills`: スキル追加・削除・リネーム時の整合性検査・修復、上流からの取り込み手順
- `skill-selection`: 上流リポジトリからのスキル選定と `AGENTS.md` / `CLAUDE.md` 更新
- `skill-escalation`: スキル本体の改良提案を本リポジトリへ Issue として起票
- `commit-and-git`: Git / GitHub 操作の規約
- `issue-branch-pr-flow`: パッチ以外の実装作業の Issue / PR フロー
