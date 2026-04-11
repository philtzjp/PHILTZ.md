The keywords "MUST", "NEVER", "SHOULD", and "MAY" in this document are to be interpreted as described in RFC 2119.

# Code Rules
1. MUST follow these naming and formatting conventions: `snake_case` for variables, `camelCase` for functions, `PascalCase` for types, `CONSTANT_CASE` for env vars, 4-space indent, no unnecessary semicolons, prefer double quotes
2. MUST use descriptive names even if verbose (NG: `const handle = () => {}`)
3. IF backward compatibility is deemed necessary -> MUST confirm with the user before proceeding
4. NEVER use fallback values in constants (NG: `web_url: process.env.WEB_URL || 'http://localhost:3000'`)
5. NEVER use fallback values in functions; MUST return an error on failure
6. MUST define all error messages in a single file
7. MUST define all log messages in a single file
8. MUST define all types in files within a dedicated directory
9. SHOULD objectify variable names to normalize them into single words (e.g., `worksName` -> `works.name`)
10. MUST use a modular monolith architecture
11. NEVER use prefixes such as `NUXT_` or `NUXT_PUBLIC_` and `VITE_` for environment variable names
12. NEVER write or format inline code within directives as multi-line (it causes errors and won't work)

## Packages
1. MUST install packages via `npm install`; NEVER write directly into `package.json`
2. IF using Nuxt -> MUST use `latest` version
3. IF using Firebase -> MUST use `firebase-admin`; NEVER use client packages
4. IF processing dates -> MUST use `date-fns`
5. IF implementing AI-related features -> SHOULD prefer Vercel AI SDK
6. IF implementing `Slack`, `Discord`, `Microsoft Teams`, `GitHub`, `Telegram`, `Linear` integrations -> MUST use Vercel Labs Chat SDK
7. IF using `unkey` -> MUST use the v2 SDK

## Google Analytics
1. MUST ask about cookie usage and send a consent signal upon agreement
2. `analytics_storage` MUST always be `granted` (basic analytics are always enabled)
3. `ad_storage`, `ad_user_data`, `ad_personalization` SHOULD be `granted` by default
4. IF user selects "Do not consent" -> MUST update advertising-related values to `denied`

## Environment Variables
1. MUST use `dotenvx` for `.env` file encryption and injection; startup command MUST be `dotenvx run -- <command>`
2. MUST define all environment variables in a single `env.ts` using `zod` schema (`envSchema`)
3. MUST validate with `envSchema.safeParse(process.env)` at startup; IF validation fails -> MUST log field errors and `process.exit(1)`
4. MUST export a typed `env` object and `Env` type (`z.infer<typeof envSchema>`) from `env.ts`
5. NEVER reference `process.env` directly outside `env.ts`; all other files MUST use `import { env } from "@/env"`
6. Default values MUST only be defined via `.default()` within the zod schema in `env.ts`; NEVER use `||` or `??` fallbacks elsewhere
7. `.env.example` is unnecessary; the zod schema in `env.ts` serves as the single source of truth for variable names, types, defaults, and validation rules

## API Design
1. MUST conform to OpenAPI
2. Error response structure MUST conform to RFC 9457
3. MUST use URL path versioning (e.g., `/api/v1/`)
4. SHOULD adopt paths as short as possible; IF unavoidable -> MUST use `kebab-case`
5. MUST use singular nouns (`/user` instead of `/users`)
6. MUST use Bearer authentication
7. Health check endpoint structure MUST conform to [draft-inadarei-api-health-check](https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check)
8. MUST lint the API using [Spectral](https://github.com/stoplightio/spectral)
9. SHOULD use [Hono](https://hono.dev/) as the HTTP framework; IF building an MCP server -> MUST use Hono with `@hono/mcp`

# Operational Rules
1. MUST record all data models in `llm/models.yaml`; IF implementation changes -> MUST update this file
2. IF bulk find-and-replace is preferable -> SHOULD write a `.js` script inside `temp/`, execute it, then delete the script
4. MUST introduce Biome & ESLint Vue and run format commands as appropriate
5. NEVER run `biome check --fix --unsafe` on `.vue` files (Biome cannot analyze Vue template scope, causing false positives like `_` prefix renaming)
6. MUST always respond in Japanese
7. IF a service version change is deemed necessary -> MUST update `VERSION` based on Semantic Versioning and create `llm/version/${version}.md`
8. IF architecture changes -> MUST update the Mermaid diagram in `./llm/ARCHITECTURE.md`

## Commit Messages
1. MUST use the format `type: description (in Japanese, short sentence)`
2. For monorepos: MUST use the format `type(scope): description (in Japanese, short sentence)`
3. MUST split commits by logical scope (package, feature); NEVER bulk-commit unrelated changes together
4. MUST analyze `git diff` per file to determine author:
   - Only Claude-generated changes -> MUST set author and committer to Claude (`GIT_COMMITTER_NAME="Claude" GIT_COMMITTER_EMAIL="noreply@anthropic.com" git commit --author="Claude <noreply@anthropic.com>"`)
   - Contains user-edited changes -> MUST NOT override author or committer
   - When uncertain -> SHOULD ask the user
5. NEVER add `Co-Authored-By`
6. NEVER use `git add .` or `git add -A`
7. NEVER mix unrelated changes in a single commit

| Prefix | Usage |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `perf` | Performance improvement |
| `refactor` | Code improvement without functional changes |
| `docs` | Documentation changes |
| `style` | Code style fixes |
| `test` | Adding or modifying tests |
| `chore` | Miscellaneous tasks |
| `ci` | CI/CD configuration changes |
| `build` | Build configuration changes |

## Git Operations
1. MUST run `git fetch --prune` before any git operation (commit, push, branch creation, merge, rebase)
2. MUST check if current branch has been merged into default branch; IF merged -> warn user and suggest switching
3. MUST check if remote tracking branch still exists; IF deleted -> warn user
4. MUST check if local branch is behind remote; IF behind -> suggest `git pull --rebase`
5. IF local branch diverged from remote -> SHOULD warn user, suggest rebase or merge
6. NEVER silently switch branches without user confirmation
7. NEVER run `git pull` or `git rebase` without user approval
8. NEVER delete local branches without user confirmation

## Test Responsibility
1. MUST create and run E2E tests after implementing a new user-facing feature, significant UI change, or user flow modification
2. MUST use agent-browser as the primary E2E testing tool; fall back to Playwright only for interactions agent-browser cannot handle (canvas manipulation, fine-grained mouse sequences, touch gestures, network interception, multi-page/cross-origin flows, WebSocket/SSE assertions)
3. IF falling back to Playwright -> MUST note in the test file why agent-browser was insufficient
4. MUST NOT trigger for: pure backend/API changes, documentation-only changes, config/dependency updates, refactors with no behavioral change
5. NEVER skip writing tests for a new user-facing feature
6. NEVER use Playwright when agent-browser can handle the interaction
7. NEVER write tests that depend on timing (`sleep`) — MUST use explicit wait conditions

## TypeScript Monorepo
1. MUST follow Turborepo + workspace (pnpm / npm) best practices
2. MUST detect package manager from lock file (`pnpm-lock.yaml` -> pnpm, `package-lock.json` -> npm); use consistently
3. MUST follow `apps/` (deployable applications) + `packages/` (shared libraries & config) separation
4. NEVER place deployable apps in `packages/`; NEVER place shared libraries in `apps/`
5. MUST use scoped package names with `@<org>/` prefix; all internal packages MUST have `"private": true`
6. MUST define `exports` in each package's `package.json`; prefer `exports` over `main`
7. MUST create shared TypeScript config in `packages/typescript-config/`; each package MUST extend it
8. MUST create `turbo.json` with dependency-aware task pipeline
9. MUST use workspace protocol for internal dependencies (`workspace:*` for pnpm, `*` for npm)
10. Default to JIT (Just-in-Time) compilation pattern; switch to compiled (`tsc` -> `dist/`) only when explicitly requested
11. NEVER create nested packages; NEVER install Turborepo globally — use `npx turbo` or root devDependency

## Migration Procedure
1. MUST create an API to retrieve the number of data records subject to migration
2. MUST create an API to perform the migration and execute a Dry Run
3. IF pre-fetched data count == Dry Run changed count -> proceed to step 4
   ELSE -> MUST fix and re-run
4. MUST execute the migration, then delete the API
