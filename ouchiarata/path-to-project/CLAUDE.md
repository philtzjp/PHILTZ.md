PROJECT_NAME=`${プロジェクト名}`
HOSTING_DOMAIN=`https://${ドメイン}`
AUTHER=`Arata Ouchi`
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

# Prohibited Actions
1. NEVER deploy to Vercel or perform any operations that affect the production environment
