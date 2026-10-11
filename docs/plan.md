# Plan
## Short
1. basics - foundation
2. services - functional
3. other stuff

## Questions to decides:
1. Proxmox VE or KVM on NIXOS
    - both bare-metal
    final decision: Proxmox VE - gives it easier.
2. where to deploy CI/CD 
    final decision: at maria
3. solve VDS naming problem
    final decision: vds-COUNTRYNUMBER (eg vds-ru1)

## Full
### Stage 1. Foundation
**DONE**: 1. deploy nixos builder on main infra
**DONE**: 2. rent new vds
**DONE**: 3. install nixos on new vds (using builder)
**DONE**: 4. secrets refactor & re-setup
**DONE**:     - [X] generate key for accesing every host from laptop, remove old keys
**DONE**:     - [X] generate key on every host
**DONE**:     - [X] add to sops (each host secrets using it's own sops key)

5. pipeline 
    - CI/CD
6. basic configure new VDS
    - Headscale
    - nginx

### Stage 2. Preparations
1. fully configure VDS;
   migrate to new vds as entry point
    - DNS server (.home.arpa)
    - miniserve
    - fail2ban
    - firewall
    - auto certs renew

2. Proxmox VE on maria
3. security audit 
4. refactor existed all
    - nginx
    - other host's configs
    - pages
    
5. some basic services
    - analytics, monitors
    - alerts (at least to matrix)

6. use native nix-envs instead of docker for services
    - from day 0 at VDS
    - migrate some services on main infra to nix

7. backups
    - create backups file structure
    - setup basic backups automations

8. prepare sops-nix (or migrate to agenix) for increases
9. migrate chat.lexa-projects.ru -> chat.lexa-services.ru

### Stage 3. Main services itself deployment
1. Auth service
2. Cloud services
    - seafiles (using ~80% of their abilities)
    - ilmmch (to backup phone gallery)
    - something as dropbox (to share files easily and without problems)
    - nextcloud (for calendars, notes, etc)
    - maybe notion for notes (OSS Obsidian alternative)
3. OCR service
4. git service
5. mail server

### Stage 4. Afterward
1. rent vds outside russia, install nixos
2. add to VPN
3. try to route traffic, try tg bots.
