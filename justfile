# List available recipes
default: 
    @just --list

# Initialize packer configuration
init:
  packer init config.pkr.hcl

# Build Alpine Linux 3.23 Template
alpine-323:
  packer build -var-file="alpine-3.23.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Alpine Linux 3.24 Template
alpine-324:
  packer build -var-file="alpine-3.24.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Debian 13 Template
debian-12:
  packer build -var-file="debian-12.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Debian 13 Template
debian-13:
  packer build -var-file="debian-13.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build RockyLinux 9 Template
rocky-9:
  packer build -var-file="rocky-9.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build RockyLinux 10 Template
rocky-10:
  packer build -var-file="rocky-10.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Ubuntu 24 Template
ubuntu-2404:
  packer build -var-file="ubuntu-24.04.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Build Ubuntu 26 Template
ubuntu-2604:
  packer build -var-file="ubuntu-26.04.pkrvars.hcl" -only=build.proxmox-iso.vm .

# Test Build Templates
test template_id="1006":
  cd terraform-template-test && terraform init && TF_VAR_template_id={{template_id}} terraform test