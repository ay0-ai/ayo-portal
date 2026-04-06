# Ay0ne Portal

See [README.md](README.md) for full project context, setup, and architecture.

## Business Modules (MVP)

- **Materials Management** — material CRUD, transaction history, accounting integration
- **Production Planning** — recipes, optimizer engine, daily production view
- **Employees Management** — user directory, time-off requests, approval workflows
- **Integrations** — Google Sheets / Slack / Notion sync on configurable frequency
- **Auth** — Google SSO (Microsoft later)
- **i18n** — English + Vietnamese minimum

## Architecture Constraints

- This is an ERPNext app on Frappe Framework — follow Frappe patterns (DocTypes, hooks, API)
- Do not introduce Django, React, or standalone frontend frameworks
- Multi-tenancy is handled by Frappe's site-based isolation
- Frontend customizations use Frappe UI (Vue-based)

## Upstream Merge Protocol

Remotes:
- `origin` — `git@github.com:ay0-ai/ayo-portal.git` (private)
- `upstream` — `https://github.com/frappe/erpnext.git` (read-only)

To pull upstream ERPNext changes:

```bash
git fetch upstream develop
git merge upstream/develop
```

**Conflict policy:** Files we have permanently diverged from upstream (e.g. `README.md`, `CLAUDE.md`, any Ay0ne-specific config) should always resolve in favor of **ours** during merge. Use `git checkout --ours <file>` for these, then commit.

When adding Ay0ne-specific files, prefer placing them in a dedicated directory or namespace (e.g. `erpnext/ay0ne/`) to minimize future merge conflicts with upstream.
