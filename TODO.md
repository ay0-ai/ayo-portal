# TODO

- [ ] Upgrade Python from 3.12 to 3.14 in `devenv.nix` — verify Frappe and all dependencies build cleanly before merging
- [ ] Upgrade AKS VM from `Standard_B2s_v2` to `Standard_B4s_v2` when user load increases — requires node pool replacement (~10 min downtime)
- [ ] Upgrade Azure Redis from Basic C0 to Standard C1 — adds replication, SLA, and failover
