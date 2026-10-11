# Decisions
**Note**: as plain list for now


## Questions to decides:
1. Proxmox VE or KVM on NIXOS
    - both bare-metal
    final decision: separated host

2. where to deploy CI/CD 
    final decision: at maria

3. solve VDS naming problem
    final decision: vds-COUNTRYNUMBER (eg vds-ru1)

4. secretes configuration:
    separated key for sshing into every host
    separated key on every host
    using restricted key for CI/CD
    sops-nix ofcs

