# List available recipes
default: 
    @just --list

# Initialize packer configuration
init:
  packer init config.pkr.hcl

# Test build templates
test template_id="1006":
  infisical run --env=dev --path=/ -- sh -c ': "${PKR_VAR_node:?PKR_VAR_node must be set in Infisical}" && cd terraform-template-test && terraform init && TF_VAR_node="$PKR_VAR_node" TF_VAR_proxmox_host="$PKR_VAR_proxmox_host" TF_VAR_proxmox_user="$PKR_VAR_proxmox_user" TF_VAR_proxmox_password="$PKR_VAR_proxmox_password" TF_VAR_proxmox_token="$PKR_VAR_proxmox_token" TF_VAR_template_id={{template_id}} terraform test'

# Build Alpine Linux 3.23 Template
alpine-323:
  infisical run --env=dev --path=/ -- packer build -force -var-file="alpine-3.23.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Alpine Linux 3.24 Template
alpine-324:
  infisical run --env=dev --path=/ -- packer build -force -var-file="alpine-3.24.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Debian 13 Template
debian-12:
  infisical run --env=dev --path=/ -- packer build -force -var-file="debian-12.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Debian 13 Template
debian-13:
  infisical run --env=dev --path=/ -- packer build -force -var-file="debian-13.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build RockyLinux 9 Template
rocky-9:
  infisical run --env=dev --path=/ -- packer build -force -var-file="rocky-9.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build RockyLinux 10 Template
rocky-10:
  infisical run --env=dev --path=/ -- packer build -force -var-file="rocky-10.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Ubuntu 24 Template
ubuntu-2404:
  infisical run --env=dev --path=/ -- packer build -force -var-file="ubuntu-24.04.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Ubuntu 26 Template
ubuntu-2604:
  infisical run --env=dev --path=/ -- packer build -force -var-file="ubuntu-26.04.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Windows Server 2025 Template
win2025:
  infisical run --env=dev --path=/ -- packer build -force -var-file="windows-server-2025.pkrvars.hcl" -only=build.proxmox-iso.vm .
