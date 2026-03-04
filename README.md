# Agent Instructions

> A collection of instruction documents for AI agents used by Philtz members.

PhiltzメンバーがAIエージェントに与える指示ドキュメントをまとめたリポジトリです。

---

## Structure

各ディレクトリにメンバーごとの指示ファイルが格納されています。

```
├── ouchiarata/              # 各メンバー名フォルダがホームディレクトリとする
│   └── path-to-project/     # このフォルダ内は各プロジェクトのルートディレクトリとする
│       ├── CLAUDE.md        # Claude Code 用の指示ファイル
│       └── AGENTS.md        # Codex CLI 等の指示ファイル
└── ...
```

## Usage

`CLAUDE.md`は[Claude Code](https://docs.anthropic.com/en/docs/claude-code)がプロジェクトのコンテキストとして読み込む設定ファイルです。
`AGENTS.md`は[Codex CLI](https://developers.openai.com/codex)や[GitHub Copilot](https://github.com/features/copilot)、[Cursor](https://cursor.com/)などがプロジェクトの指示として読み込むファイルです。

`membername/path-to-project/CLAUDE.md`は、**リポジトリルート**に配置することで、`membername/.claude/`は`~./claude`に配置することで、共通の指示として適用できます。

## Connect with Us

私たちの活動に関するより詳しい情報は、公式サイトをご覧ください。

- **Official Website:** https://philtz.com
