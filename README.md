# Ay0ne Portal

Multi-tenant manufacturing operations platform for continuous processing businesses (wood pellets, animal feed, cement). First customer: **Ayo Biomass**.

Built on [ERPNext](https://github.com/frappe/erpnext) / [Frappe Framework](https://github.com/frappe/frappe).

## Business Modules

### Materials Management
- Integration with accounting software for pulling materials transaction data
- Material CRUD, transaction history (IN / OUT / ADJUSTMENT)

### Production Planning
- Recipe management (draft / active / archived)
- Optimizer engine (algorithm TBD, Koidra.ai integration planned)
- Daily production view

### Employees Management
- User directory
- Time-off requests with manager approval workflow

### Integrations
- Google Sheets, Slack, Notion sync (configurable frequency)
- Accounting driver interface

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | [Frappe](https://github.com/frappe/frappe) + ERPNext |
| Backend | Python, PostgreSQL 16, Redis |
| Frontend | Frappe UI (Vue-based) |
| Auth | SSO (Google first, Microsoft later) |
| i18n | English + Vietnamese minimum |

## Development Setup

### Prerequisites

- [Nix](https://nixos.org/) — install via [Determinate Systems installer](https://install.determinate.systems/nix):
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```
- [devenv](https://devenv.sh/) — after nix is installed:
  ```bash
  nix profile install nixpkgs#devenv
  ```
- [direnv](https://direnv.net/) (optional but recommended) — auto-activates the environment when you `cd` into the project:
  ```bash
  nix profile install nixpkgs#direnv
  echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc   # or bash equivalent
  ```

### Environment Management with Nix

All system dependencies (Python 3.12, Node 20, PostgreSQL 16, Redis, wkhtmltopdf, build libs) are declared in `devenv.nix`. No manual installation of these is needed.

```bash
# Enter the dev shell (installs everything on first run)
devenv shell

# Or with direnv: just cd into the project directory
cd ayo-portal
direnv allow   # one-time approval

# Start PostgreSQL and Redis as background services
devenv up       # runs in foreground; use a separate terminal or add -d

# Install bench CLI
pip install frappe-bench
```

### First-Time Setup

```bash
# Initialize a bench environment (from parent directory)
cd ..
bench init --frappe-branch version-15 ayo-bench
cd ayo-bench

# Link this repo as an app
bench get-app /path/to/ayo-portal   # or git@github.com:ay0-ai/ayo-portal.git

# Create a site and install
bench new-site ayo.localhost
bench --site ayo.localhost install-app erpnext

# Start development servers
bench start
# Open http://ayo.localhost:8000
```

### Key devenv Commands

| Command | What it does |
|---------|-------------|
| `devenv shell` | Enter dev shell with all dependencies |
| `devenv up` | Start PostgreSQL + Redis services |
| `devenv test` | Run tests (if configured) |
| `devenv gc` | Garbage-collect old environments |

### Docker

See [Frappe Docker](https://github.com/frappe/frappe_docker) for containerized / production setup.

## Git Workflow

This repo tracks upstream ERPNext. See `CLAUDE.md` for merge instructions.

- `master` — our main branch (tracks `upstream/develop` from frappe/erpnext)
- `upstream` remote — `https://github.com/frappe/erpnext.git` (read-only)
- `origin` remote — `git@github.com:ay0-ai/ayo-portal.git`
