# Backups scheme

# Infrastructure
## Principles
### Naming
1. vds names: vds-country-number
2. servers names: using real names (bcs not much of them)

### Security
1. ssh only with PGP keys NO PASSWORDS
2. close everything possible
3. secrets stored in sops-nix
4. secretes configuration:
    separated key for sshing into every host
    separated key on every host
    using restricted key for CI/CD
    sops-nix ofcs

### Service deploy
**When deploying, should be done**:
1. document:
    - decisions, files, etc
    - plans, improving points
    - weak points
    - security notes
3. setup
    - backups
    - security
    - alerts, monitoring, etc

### Domains
*.lexa-projects.ru - docs only, just static pages
    music.lexa-projects.ru -> lexa-music.ru (forward with code 301)
*.lexa-services.ru - the services itself

## Hosts
### `vds-ru1`
**Description**: Entry point, first security barrier
**OS**: NixOS
**IP**: public static
**Status**: migrating to it (installed nixos on it)
**Specs**:
    - 1 vCPU
    - 512mb ram
    - 20gb ssd
    - the only public IP
**Services**:
    - headscale
    - DNS server
    - nginx
    - miniserv (centralized html sender, used by nginx)
**Security**:
    - open ports: 443, 80 (with forwarding to 443); dns server's port
    - fail2ban + some prison on headscale request by ip, or on all http/s request (find limit so it does not block my infra)

### `vds-old`
**Description** old version of vds-ru1, on debian
**OS**: NixOS
**IP**: public static
**Status**: still in use
### `vds-eu1`
**Description**: exit-point for some services (e.g. for tg bots, for AI API, etc)
**Status**: not rented

### `anton`
**Description**: Main powerful and stable machine for services
**OS**: NixOS
**IP**: dynamic
**Status**: ready for services, have some
**Specs**:
    - CPU: xeon E31230 (V1)
    - GPU: nvidia gt 1030
    - 32ram
    - 512gb nvme m2 Samsung PM981 512GB (OEM 970 EVO not for retail) ssd
    - 1tb hdd
**Services**:
    - chat
    - cloud
    - storage (internal service for backups)
    - OCR (using GPU if possible)
    - Auth
**Security**:
    - open ports: per-services (not confirmed exact)
    - backups stored here on hdd, with cold data.

### `maria`
**what**: second server, for experiments / other services
**OS**: NixOS
**IP**: dynamic
**Status**: ready for services
**Specs**:
    - CPU: i3 gen8 (Intel(R) Celeron(R) 3865U (2) @ 1.80 GHz)
    - GPU: intel HD Graphics
    - 16gb ram
    - 512gb ssd
**services**:
    - nixos builder
    - cache
    - telemetry, analytics, alerts
    - CI/CD
**Security**:
    - open powerts: per-services
    - backuping to anton

### `olga` (not sure about name yet)
**Description**: host for VMs (throwaway vms e.g. to share with someone / experiment)
**OS**: Proxmox VE
**Status**: not connected yet
**Specs**:
    - CPU: xeon E31270 (V1)
    - 16gb ram
    - 512gb ssd

