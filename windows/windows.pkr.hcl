packer {
    required_plugins {
        proxmox = {
            version = "1.1.3"
            source  = "github.com/hashicorp/proxmox"
        }
        windows-update = {
            version = "0.14.3"
            source  = "github.com/rgl/windows-update"
        }
    }
}

source "proxmox-iso" "windows-template" {
  # proxmox connection details
  proxmox_url = var.proxmox_api_url
  username  = var.proxmox_api_token_id
  token = var.proxmox_api_token_secret
  insecure_skip_tls_verify = var.proxmox_api_insecure_skip_tls_verify

  # general vm settings
  node = var.proxmox_node
  vm_id = var.vm_id
  vm_name = var.vm_name
  template_description = var.vm_template_description
  os = var.vm_os

  # vm hardware settings
  sockets = var.vm_sockets
  cores = var.vm_cores
  cpu_type = var.vm_cpu_type
  memory = var.vm_memory
  bios = var.vm_bios
  scsi_controller = var.vm_scsi_controller

  efi_config {
    efi_storage_pool = var.proxmox_vm_storage_pool
  }
  
  disks {
    disk_size = var.vm_disk_size
    format = var.vm_disk_format
    storage_pool = var.proxmox_vm_storage_pool
    type = var.vm_disk_type
  }

  network_adapters {
    bridge = var.proxmox_vm_network_bridge
    model = var.vm_network_model
    firewall = var.vm_network_firewall
  }

  # vm installation settings
  iso_file = "${var.proxmox_iso_storage_pool}:iso/${var.proxmox_os_iso}"

  additional_iso_files {
    device = "sata1"
    iso_file = "${var.proxmox_iso_storage_pool}:iso/${var.proxmox_virtio_iso}"
  }

  additional_iso_files {
    device = "sata2"
    cd_files = [ "scripts/winrm_config.ps1" ]
    cd_content = {
      "/autounattend.xml" = templatefile("${path.root}/unattend/unattend-${var.vm_build_type}.xml.pkrtpl.hcl",
        {
          image_name = var.vm_os_windows_image_name
          product_key = var.vm_os_windows_product_key
          owner_name = var.vm_os_windows_owner_name
          org_name = var.vm_os_organization_name
          computer_name = var.vm_os_computer_name
          time_zone = var.vm_os_time_zone
          administrator_password = var.vm_os_administrator_password
          locale = var.vm_os_locale
        }
      )
    }
    iso_storage_pool = var.proxmox_iso_storage_pool
  }

  # boot settings
  boot_command = ["<enter>"]
  boot_wait    = var.vm_boot_wait

  # connection settings
  communicator = "winrm"
  winrm_username = "Administrator"
  winrm_password = var.vm_os_administrator_password
  winrm_insecure = true
  winrm_use_ssl = true
  winrm_timeout = "1h"
}

build {
  sources = [ "source.proxmox-iso.windows-template" ]

  # download and apply all windows updates
  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
  }

  # sysprep the VM for reuse as a template
  provisioner "windows-shell" {
    inline = [ "C:\\Windows\\System32\\Sysprep\\Sysprep.exe /generalize /oobe /quit /quiet" ]
  }

  # TODO: add a post-processor to remove the build CDROM drives from the template
}