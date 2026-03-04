---
description: API設計、OpenAPI、Hono、エンドポイント作成、MCP Server構築を扱うとき
alwaysApply: false
---

# API Design

1. MUST conform to OpenAPI
2. Error response structure MUST conform to RFC 9457
3. MUST use URL path versioning (e.g., `/api/v1/`)
4. SHOULD adopt paths as short as possible; IF unavoidable -> MUST use `kebab-case`
5. MUST use singular nouns (`/user` instead of `/users`)
6. MUST use Bearer authentication
7. Health check endpoint structure MUST conform to [draft-inadarei-api-health-check](https://datatracker.ietf.org/doc/html/draft-inadarei-api-health-check)
8. MUST lint the API using [Spectral](https://github.com/stoplightio/spectral)
9. SHOULD use [Hono](https://hono.dev/) as the HTTP framework; IF building an MCP server -> MUST use Hono with `@hono/mcp`
