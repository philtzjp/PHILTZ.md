---
description: npm install、パッケージ選定、Nuxt/Firebase/date-fns/AI SDK/Chat SDK/unkey を扱うとき
globs:
  - package.json
  - package-lock.json
alwaysApply: false
---

# Package Rules

1. MUST install packages via `npm install`; NEVER write directly into `package.json`
2. IF using Nuxt -> MUST use `latest` version
3. IF using Firebase -> MUST use `firebase-admin`; NEVER use client packages
4. IF processing dates -> MUST use `date-fns`
5. IF implementing AI-related features -> SHOULD prefer Vercel AI SDK
6. IF implementing `Slack`, `Discord`, `Microsoft Teams`, `GitHub`, `Telegram`, `Linear` integrations -> MUST use Vercel Labs Chat SDK
7. IF using `unkey` -> MUST use the v2 SDK
