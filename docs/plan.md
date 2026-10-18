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
**DONE**:     - [X] generate key for accessing every host from laptop, remove old keys
**DONE**:     - [X] generate key on every host
**DONE**:     - [X] add to sops (each host secrets using it's own sops key)

5. CI/CD pipeline 
    - [X] deploy-rs
    - [X] builder on infra
    - [ ] git hook on builder

6. fully configure new VDS
   migrate to new VDS as entry point
    - Headscale
    - nginx
    - DNS server (.home.arpa)
    - miniserve
    - fail2ban
    - firewall
    - auto certs renew

7. refactor
    - security audit
    - nix
    - nginx
    - pages
    
8. some fundamental services
    - analytics, monitors
    - alerts (at least to matrix)

9. use native nix-envs instead of docker for services
    - from day 0 at VDS
    - migrate some services on main infra to nix

10. backups
    - create backups file structure
    - setup basic backups automations

11. migrate chat.lexa-projects.ru -> chat.lexa-services.ru

### Stage 2. Main services itself deployment
1. Proxmox VE on *olga* (not final name)
2. Auth service
3. Cloud services
    - seafiles (using ~80% of their abilities)
    - ilmmch (to backup phone gallery)
    - something as dropbox (to share files easily and without problems)
    - nextcloud (for calendars, notes, etc)
    - maybe notion for notes (OSS Obsidian alternative)
4. OCR service
5. git service
6. mail server

### Stage 3. Afterward
1. rent vds outside russia, install nixos
2. add to VPN
3. try to route traffic, try tg bots.
