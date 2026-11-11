provider "proxmox" {
  endpoint = "https://${var.proxmox_host}"

  api_token = var.proxmox_token != "" ? "${var.proxmox_user}=${var.proxmox_token}" : null
  username  = var.proxmox_token == "" ? var.proxmox_user : null
  password  = var.proxmox_token == "" ? var.proxmox_password : null
}