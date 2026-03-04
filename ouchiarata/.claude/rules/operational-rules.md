---
description: データモデル管理、環境変数変更、Biome/ESLint、バージョニング、アーキテクチャ図更新を扱うとき
alwaysApply: false
---

# Operational Rules

1. MUST record all data models in `llm/models.yaml`; IF implementation changes -> MUST update this file
2. IF environment variables change -> MUST update `.env.example`
3. IF bulk find-and-replace is preferable -> SHOULD write a `.js` script inside `temp/`, execute it, then delete the script
4. NEVER run `npm run dev` in the background; MUST prompt the user to run it
5. MUST introduce Biome & ESLint Vue and run format commands as appropriate
6. NEVER run `biome check --fix --unsafe` on `.vue` files (Biome cannot analyze Vue template scope, causing false positives like `_` prefix renaming)
7. MUST always respond in Japanese
8. IF a service version change is deemed necessary -> MUST update `VERSION` based on Semantic Versioning and create `llm/version/${version}.md`
9. IF architecture changes -> MUST update the Mermaid diagram in `./llm/ARCHITECTURE.md`
