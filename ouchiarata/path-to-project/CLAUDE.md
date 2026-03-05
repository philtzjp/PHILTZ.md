PROJECT_NAME=`${プロジェクト名}`
HOSTING_DOMAIN=`https://${ドメイン}`
AUTHER=`Arata Ouchi (${Original SIN Architecture または Philtz})`
AUTHER_XID=`@ouchiarata`
AUTHER_URL=`https://${osa.xyz または philtz.com}$`
PAGE_TITLE=`${ページタイトル}`
SHORT_DESCRIPTION=`${サイト内キャッチコピー等に使用できる短い説明}`
LONG_DESCRIPTION=`${ページデスクリプション等に使用できる正式な説明}`

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
2. IF environment variables change -> MUST update `.env.example`
3. IF bulk find-and-replace is preferable -> SHOULD write a `.js` script inside `temp/`, execute it, then delete the script
4. NEVER run `npm run dev` in the background; MUST prompt the user to run it
5. MUST introduce Biome & ESLint Vue and run format commands as appropriate
6. NEVER run `biome check --fix --unsafe` on `.vue` files (Biome cannot analyze Vue template scope, causing false positives like `_` prefix renaming)
7. MUST always respond in Japanese
8. IF a service version change is deemed necessary -> MUST update `VERSION` based on Semantic Versioning and create `llm/version/${version}.md`
9. IF architecture changes -> MUST update the Mermaid diagram in `./llm/ARCHITECTURE.md`

## Commit Messages
1. MUST use the format `type: description (in Japanese, short sentence)`
2. MUST perform a dry run (`git commit --dry-run`) before committing, present the commit message to the user, and MUST only execute after receiving approval
3. NEVER add `Co-Authored-By`

| Prefix | Usage |
|---|---|
| `feat` | Adding a new feature |
| `fix` | Bug fix |
| `perf` | Performance improvement |
| `refactor` | Code improvement without functional changes |
| `docs` | Documentation changes |
| `style` | Code style fixes |
| `test` | Adding or modifying tests |
| `chore` | Miscellaneous tasks |
| `ci` | CI/CD configuration changes |
| `build` | Build configuration changes |

## Migration Procedure
1. MUST create an API to retrieve the number of data records subject to migration
2. MUST create an API to perform the migration and execute a Dry Run
3. IF pre-fetched data count == Dry Run changed count -> proceed to step 4
   ELSE -> MUST fix and re-run
4. MUST execute the migration, then delete the API

# Prohibited Actions
1. NEVER deploy to Vercel or perform any operations that affect the production environment