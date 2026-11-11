# Packer Templates for Proxmox

**Tested with with Proxmox 9.1.2, Packer 1.14 and Packer Proxmox Plugin v1.2.3**

Build VM Templates with Packer for Proxmox. The generated templates are meant to be used with cloud-init, they come without a User or root login.
Only the Windows Server Template has a Administrator user by default (Password `packer`). It's ready for Ansible setup via winrm.

**All templates are made for my personal environment and may need adjustments for yours!**

## How to build

### Prepare Packer

First initialize the proxmox packer plugin:

```sh
packer init config.pkr.hcl
```

### Configure Infisical and your variables

The templates all use a generic source builder ([generic.pkr.hcl](./generic.pkr.hcl)) that's driven by variables. The OS specific settings are only variables and preseed files.

Install the Infisical CLI, authenticate with `infisical login`, and link this directory to your Infisical project with `infisical init`. Add the following secrets to the `dev` environment at `/`. Name them exactly as shown so Packer receives them as input variables:

- `PKR_VAR_proxmox_host`
- `PKR_VAR_proxmox_user`
- `PKR_VAR_node`
- `PKR_VAR_proxmox_password` or `PKR_VAR_proxmox_token` (depending on your Proxmox authentication method)

The OS-specific `.pkrvars.hcl` files continue to provide each template's non-secret settings. You can override other variables with a `-var-file`, `-var`, or `PKR_VAR_<name>` environment variable as needed.

Other interesting variables are:

- pool
- proxmox_insecure_tls
- disk_storage_pool
- iso_storage_pool
- cloud_init_storage_pool
- iso_download
- Windows:
  - windows_edition
  - windows_language / windows_input_language
  - winrm_username / winrm_password (Win11 alway creates a user, Win Server will use Administrator)

See [variables.pkr.hcl](./variables.pkr.hcl) for all varaibles.

### Build a template

Build a template (e.g. `debian-13`) with the corresponding recipe:

```sh
just debian-13
```

The build recipes run Packer through `infisical run --env=dev --path=/`, so the secrets are injected into the Packer process rather than loaded from a local `*.auto.pkrvars.hcl` file.



## Template Generalization

All templates are generalized before being sealed, so clones get unique identities.

**Linux** (via the shell provisioner in each `*.pkrvars.hcl`): `cloud-init clean --logs` resets cloud-init state, SSH host keys are deleted (cloud-init regenerates them on first boot), `/etc/machine-id` is emptied so every clone gets a fresh machine ID (prevents duplicate DHCP leases with systemd-networkd), the `packer` build user is removed including its home directory, and package caches, shell history and logs are wiped. A final `fstrim` keeps the thin-provisioned disk small.

## Useful Tips

### Packer Webserver Forwarding

In some cases your proxmox server might be in a datacenter. You can ssh to the proxmox server but the proxmox server can't connect to your build computer.

Set the following variables in your configuration.

- packer_http_interface to `127.0.0.1`
- packer_http_port to `8000`

**Your Proxmox Server can be reached via ssh**

Start this in a console on your build host and keep it open during build time.

```bash
# forward 127.0.0.1:8000 to the remote proxmox to 127.0.0.1:8000
ssh -N -R 127.0.0.1:8000:127.0.0.1:8000 root@proxmox
```

**Your Proxmox Server can't be reached from the build computer via ssh**

In this case you need a 2nd computer that can be reached from the proxmox computer and the build computer acting as relais.

On the proxmox host:

```bash
ssh -N -L 127.0.0.1:8000:127.0.0.1:8000 user@lighthouse
```

On the build computer:

```bash
ssh -N -R 127.0.0.1:8000:127.0.0.1:8000 user@lighthouse
```

## Credit
This is a soft fork of work done by [pumba98](https://github.com/Pumba98)