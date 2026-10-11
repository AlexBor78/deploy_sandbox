# NixOS on a 512MB VDS — The Runbook

Battle-tested 2026-10-10 on: Selectel VDS (512MB RAM, 1 vCPU, 20GB SSD, Debian 11
only OS option, no ISO mounting, no custom image upload, BIOS boot).
Result: declarative NixOS managed from a flake on a laptop, builds offloaded to a
remote builder over WireGuard.

## Decision tree (read first — saves hours)

```
Can your provider mount an ISO / rescue media?  → use standard nixos-anywhere. DONE.
Can your provider upload custom images?          → build qcow2 from flake with
                                                   nixos-generators, upload, create
                                                   server from image. DONE (30 min).
Neither?                                          → this runbook (in-place switch).
```

Also dead, do not bother: `jeaye/nixos-in-place` (pins NixOS 16.09 ISO from 2016,
mirror 404s). `nixos-anywhere` kexec path needs >1GB RAM for the installer initrd —
fails on 512MB.

## Architecture

- **laptop** (x86_64, nix installed): flake repo, builds, `nixos-rebuild --target-host`
- **infra/anton**: NixOS builder — `builder` user, `nix.settings.trusted-users`
- **matrix-vds**: WireGuard hub (Debian), peers: anton, laptop, this box
- **vds-ru1**: the victim. Public IP static `IP/24`, gw `GATEWAY`, NIC is `eth0`
  (legacy naming forced via `net.ifnames=0`)

## Phase 0 — infra (once, reusable)

On anton (NixOS):
```nix
users.users.builder.isNormalUser = true;
users.users.builder.openssh.authorizedKeys.keys = [ "<vds root pubkey>" ];
nix.settings.trusted-users = [ "root" "builder" ];
```
On the WG hub, add peer:
```ini
[Peer]
PublicKey = <vds wg pubkey>
AllowedIPs = 10.0.0.5/32
PersistentKeepalive = 25
```
Apply live without dropping sessions: `wg syncconf wg0 <(wg-quick strip wg0)`

## Phase 1 — Debian bootstrap (on the VDS)

Provider bot creates Debian + injects your SSH key (Selectel does from day one).

```bash
# 0. recon — determines EVERYTHING about the NixOS config
lsblk -f                      # partitions, UUIDs, LABELs  (found: sda1, LABEL=cloudimg-rootfs, sda14 tiny cloud partition)
ls /sys/firmware/efi          # empty → BIOS → grub MBR
ip -br a; ip r                # NIC name (eth0), static IP, gateway
cat /etc/network/interfaces   # static vs dhcp (Selectel: STATIC)

# 1. apt (Debian 11 is ARCHIVED — live mirrors 404)
cat > /etc/apt/sources.list <<'EOF'
deb http://archive.debian.org/debian bullseye main contrib non-free
deb http://archive.debian.org/debian-security bullseye-security main contrib non-free
EOF
apt update -o Acquire::Check-Valid-Until=false
apt install -y curl xz-utils git sudo wireguard tmux

# 2. swap BEFORE anything nix (box has <512MB effective)
fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile

# 3. nix
sh <(curl -L https://nixos.org/nix/install) --daemon
echo 'source /etc/profile.d/nix.sh' >> ~/.bashrc   # tmux panes lose PATH otherwise

# 4. daemon config: offload ALL builds to anton
cat > /etc/nix/nix.conf <<'EOF'
experimental-features = nix-command flakes
builders = ssh://builder@10.0.0.2 x86_64-linux - 8 2 kvm,big-parallel,benchmark
builders-use-substitutes = true
max-jobs = 0
EOF
systemctl restart nix-daemon
nix show-config | grep -E 'builders|max-jobs'    # ground truth

# 5. keys
ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N "" -C "vds-ru1-root"   # → anton's builder user
umask 077; wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey  # → hub

# 6. wireguard client (peers WITH the hub, allowedIPs = whole tunnel subnet)
cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $(cat /etc/wireguard/privatekey)
Address = 10.0.0.5/24
[Peer]
PublicKey = <HUB_PUBKEY>
Endpoint = <HUB_PUBLIC_IP>:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF
chmod 600 /etc/wireguard/wg0.conf
systemctl enable --now wg-quick@wg0
ping 10.0.0.1 && ping 10.0.0.2    # hub, then anton THROUGH hub

# 7. prove offload (must print "anton", not the vds hostname)
ssh builder@10.0.0.2 nix-store --version          # accept host key ONCE (seeds known_hosts)
nix-channel --add https://nixos.org/channels/nixos-25.11 nixpkgs && nix-channel --update
nix-build -E 'with import <nixpkgs> {}; runCommand "who" { buildInputs = [ hostname ]; } "hostname > $out"' --no-out-link
cat /nix/store/*-who
```

## Phase 2 — the NixOS config (laptop, flake repo)

`hosts/vds-ru1/hardware-configuration.nix`:
```nix
{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_scsi" "sd_mod" ];
  fileSystems."/" = { device = "/dev/disk/by-label/cloudimg-rootfs"; fsType = "ext4"; };
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];
  boot.loader.grub = { enable = true; device = "/dev/sda"; efiSupport = false; };
}
```
`hosts/vds-ru1/default.nix` essentials:
```nix
boot.kernelParams = [ "net.ifnames=0" "biosdevname=0" ];   # NIC is eth0, don't let systemd rename
networking.networkmanager.enable = lib.mkForce false;      # if common/ enables it
networking.useDHCP = false;
networking.interfaces.eth0.ipv4.addresses = [ { address = "IP"; prefixLength = 24; } ];
networking.defaultGateway = "GATEWAY";
networking.nameservers = [ ... ];
zramSwap.enable = true;
documentation.nixos.enable = false; documentation.man.enable = false;
services.openssh.enable = true;
users.users.admin = { isNormalUser = true; extraGroups = [ "wheel" ];
  openssh.authorizedKeys.keys = [ "<laptop admin pubkey>" ]; };
system.stateVersion = "25.11";
```
Build + ship:
```bash
nix build .#nixosConfigurations.vds-ru1.config.system.build.toplevel
nix path-info .#nixosConfigurations.vds-ru1.config.system.build.toplevel   # SAVE THIS PATH
nix-copy-closure --to root@IP ./result
```

## Phase 3 — the in-place switch (VDS, in tmux)

```bash
TOPLEVEL=/nix/store/xxxx-nixos-system-vds-ru1-25.11....
export PATH=/nix/var/nix/profiles/default/bin:$PATH

# system profile
nix-env -p /nix/var/nix/profiles/system --set $TOPLEVEL

# short-named boot artifacts (long store paths in grub.cfg get mangled by
# terminal paste-wrapping — do NOT paste 100-char hashes into grub files)
cp $TOPLEVEL/kernel /boot/nixos-kernel
cp $TOPLEVEL/initrd /boot/nixos-initrd
ln -sf $TOPLEVEL/init /boot/nixos-init

cat > /etc/grub.d/40_custom <<'EOF'
#!/bin/sh
exec tail -n +3 $0
menuentry "NixOS" {
    insmod part_gpt
    insmod part_msdos
    insmod ext2
    search --no-floppy --set=root --label cloudimg-rootfs
    linux /boot/nixos-kernel root=/dev/sda1 rw init=/boot/nixos-init net.ifnames=0 biosdevname=0 console=ttyS0,115200n8 console=tty0
    initrd /boot/nixos-initrd
}
EOF

sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="NixOS"/' /etc/default/grub
grep -q '^GRUB_TIMEOUT=1[0-9]' /etc/default/grub || echo 'GRUB_TIMEOUT=10' >> /etc/default/grub
update-grub
grep -A8 'menuentry .NixOS' /boot/grub/grub.cfg     # verify BEFORE reboot
grep 'set default' /boot/grub/grub.cfg              # expect "NixOS"
head -1 /boot/nixos-init                            # must print a #! line, NOT "No such file"
```

**Why init=/boot/nixos-init matters:** NixOS stage-1 (in the initrd) does NOT know the
system path — it reads it from the kernel cmdline `init=` parameter. Without it:
`stage 2 init script (/mnt-root//init) not found` (note the empty path).

**Why search --label and not hd0,msdos1:** cloud disks may be GPT and device
numbering varies → `error: no such partition`. Label search is immune.

**Why the console order `console=ttyS0... console=tty0` LAST=tty0:** userspace
`/dev/console` goes to the LAST console= param. Last=tty0 → bash prompt and
systemd output appear on VNC. Swap the order if you're on a serial console.

## Phase 3.5 — the one weird trick (empty /etc)

Booting stage-2 directly against the populated Debian /etc fails: activation only
half-populates /etc on top of a foreign one → `Unit default.target not found.
Falling back to rescue.target... Freezing execution.` (systemd sees zero units).

Solution: give stage-2 a clean /etc, via bash-as-PID1:

1. Reboot. GRUB menu → NixOS → `e` → edit the `linux` line:
   replace `init=/boot/nixos-init` with
   `init=$TOPLEVEL/sw/bin/bash`  (verify the path first from GRUB CLI with `ls`,
   or read the shebang of `cat /boot/nixos-init` line 1 — zero hash-typing)
2. Bash prompt appears (job-control warnings normal):
```bash
export PATH=$TOPLEVEL/sw/bin:$PATH
rm -rf /etc && mkdir /etc
sync
exec $TOPLEVEL/init
```
3. Activation populates the fresh /etc → systemd → services → login prompt.
   (Why not just boot normally and clean /etc from Debian? See pitfalls: stub-ld.)

## Phase 4 — take over (laptop)

```bash
ssh-keygen -R IP                    # host keys regenerated — expected warning
nixos-rebuild switch --flake .#vds-ru1 --target-host root@IP
# (root key login: `ssh-add ~/.ssh/vds_ru1` first, or use admin@ + --use-remote-sudo)
sudo systemctl reboot               # THE test: unattended boot
```

## Pitfalls encountered (the short list of horrors)

| Symptom | Cause | Fix |
|---|---|---|
| apt 404s | bullseye archived | archive.debian.org + Check-Valid-Until=false |
| nix-env: command not found in new tmux pane | profile.d not sourced | source /etc/profile.d/nix.sh / export PATH |
| update-grub: syntax error / Incorrect command | long line wrapped during paste | short paths in /boot, rewrite 40_custom |
| stage 2 init (/mnt-root//init) not found | missing init= kernel param | add init=/boot/nixos-init |
| no such partition | hd0,msdos1 guessed wrong | search --label |
| bash prompt invisible on VNC | /dev/console = last console= | put console=tty0 last |
| Unit default.target not found, Freezing | /etc polluted by foreign distro | bash-as-PID1 → rm -rf /etc → exec init |
| Debian kernel panic exitcode=0x007f00 after partial NixOS boot | NixOS activation installed stub-ld at /lib64/ld-linux-x86-64.so.2 → Debian dynamic binaries die with exit 127 | Debian is dead. Don't need it. (This is why Phase 3.5 exists) |
| ssh host key warning | fresh NixOS host keys | ssh-keygen -R |
| nixos-rebuild target-host auth fails | -i key not offered non-interactively | ssh-add, or ~/.ssh/config IdentityFile, or admin@+sudo |
| `nix build .#nixosConfigurations.X` — type is not a string but a set | nixosConfiguration attrsets aren't directly buildable | build ...config.system.build.toplevel |
| build sandbox: hostname: command not found | sandbox has only declared deps | buildInputs = [ hostname ] |

## Post-install backlog
- fresh WG keys (old died with /etc) → then ideally declare wg in the flake
- root → anton builder key (regenerate; or skip, laptop rebuilds suffice)
- reclaim ~1GB: /usr /var/lib/dpkg /var/cache/apt /boot/nixos-* /boot/vmlinuz-*
- delete ~/nixos-install on the box when confident

## Stats
- Wall clock: ~5h first time (incl. 2 dead ends). Repeatable: 60–90 min.
- Cost: one 512MB VPS, zero data loss events that mattered, 5 reboots, 2 kernel
  panics, 1 immortal GRUB CLI session.
