# What i want
1. move from wg to headscale
  - rules
  - tags: infra; ecosystem; shared(to share something with someone, most restricted)

2. deploy cloud services:
  - seafiles (using ~80% of their abilities)
  - ilmmch (to backup phone gallery)
  - something as dropbox (to share files easily and without problems)
  - nextcloud (for calendars, notes, etc)
  - maybe notion (OSS Obsidian alternative)

3. deploy auth service
4. deploy OCR (maybe will need to write front)
5. CI/CD pipeline
  - push commit -> TESTS -> deploy
  - mirror repo to github
    
6. nix
  - cache
  - builder

7. local DNS zone (something .arpa etc)
8. find better way for static pages, so i can edit them easier
9. add out-russia node; add Telegram bot for notifs
10. refactor, finish configs and publish
11. finish security:
  - DECLARATIVE
  - firewalls, zero-trust, fail2ban-like limiters

12. Proxmox XE on one of hosts to easy shareable VMs
13. Install NixOS on VDS
14. add monitoring systems
15. try using NixOS-sandboxes instead of docker where possible

16. domains
  - structure domains: lexa-projects.ru lexa-services.ru lexa-music.ru
  - migrate chat.lexa-projects.ru -> chat.lexa-services.ru 

17. chat
  - fix media sending in chat; 
  - decides either deploy infra for calls or not.
