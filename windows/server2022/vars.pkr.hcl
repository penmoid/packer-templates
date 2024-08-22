# proxmox vars
# required info to connect to your proxmox environment and tell packer where to find the ISOs
# these are unique to your proxmox environment so defaults are generally not provided

# api connection vars
variable "proxmox_api_url" {
  description = "The URL of the Proxmox API"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "The Proxmox API token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "The Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "The name of the Proxmox node to create the VM on"
  type        = string
}

variable "proxmox_api_insecure_skip_tls_verify" {
  description = "Whether to skip TLS verification when connecting to the Proxmox API"
  type        = bool
  default     = false
}

# vm network
variable "proxmox_vm_network_bridge" {
  description = "The name of the bridge to connect the VM to"
  type        = string
  default     = "vmbr0"
}

# vm storage
variable "proxmox_vm_storage_pool" {
  description = "The name of the storage pool to create the VM on"
  type        = string
}

# iso vars
variable "proxmox_iso_storage_pool" {
  description = "The name of the storage pool containing the Windows and VirtIO ISOs"
  type        = string
}

variable "proxmox_os_iso" {
  description = "The filename of the Windows ISO - e.g. SERVER_EVAL_x64FRE_en-us.iso"
  type        = string
}

variable "proxmox_virtio_iso" {
  description = "The filename of the VirtIO driver ISO - e.g. virtio-win-0.1.229.iso"
  type        = string
}

# VM vars
# specify the VM name, CPU, RAM, disk size, network interface details, etc.
variable "vm_build_type" {
  description = "The type of VM to build - only current valid value is server-2022-desktop"
  type        = string
  default     = "server-2022-desktop"
}

variable "vm_id" {
  description = "The ID of the VM to create"
  type        = number
  default     = 9902
} 

variable "vm_name" {
  description = "The name of the VM to create"
  type        = string
  default     = "win-server-22"
}

variable "vm_template_description" {
  description = "The description to use for the generated vm template"
  type        = string
  default     = "Windows Server 2022 Standard (Desktop Experience) Template"
}

variable "vm_memory" {
  description = "The amount of memory in MB to allocate to the VM - min 1024"
  type        = number
  default     = 4096
}

variable "vm_sockets" {
  description = "The number of sockets to allocate to the VM"
  type        = number
  default     = 1
}

variable "vm_cores" {
  description = "The number of cores to allocate to the VM"
  type        = number
  default     = 2
}

variable "vm_cpu_type" {
  description = "The CPU type to use for the VM - refer to the hcp proxmox builder documentation for available options"
  type        = string
  default     = "host"
}

variable "vm_os" {
  description = "The OS type of the VM - refer to the hcp proxmox builder documentation for available options"
  type        = string
  default     = "win10"
}

variable "vm_bios" {
  description = "The BIOS type of the VM - ovmf for UEFI, seabios for BIOS. Modifications to the template are required for seabios"
  type        = string
  default     = "ovmf"
}

variable "vm_qemu_agent" {
  description = "Tell Proxmox whether to expect that the QEMU guest agent will be installed on the VM"
  type        = bool
  default     = true
}

variable "vm_network_model" {
  description = "The network model to use for the VM - refer to the hcp proxmox builder documentation for available options"
  type        = string
  default     = "virtio"
}

variable "vm_network_firewall" {
  description = "Whether to enable the firewall on the VM. This refers specifically to the proxmox firewall, not the Windows firewall"
  type        = bool
  default     = false
}

variable "vm_scsi_controller" {
  description = "The type of storage controller to use - virtio-scsi-pci is recommended for best performance"
  type        = string
  default     = "virtio-scsi-pci"
}

variable "vm_disk_size" {
  description = "The size of the VM disk in GB - min 32G"
  type        = string
  default     = "40G"
}

variable "vm_disk_format" {
  description = "The format of the VM disk - raw or qcow2"
  type        = string
  default     = "raw"
}

variable "vm_disk_type" {
  description = "The type of VM disk - scsi, ide, sata, virtio, etc."
  type        = string
  default     = "virtio"
}

variable "vm_disk_cache" {
  description = "The cache type to use for the VM disk - none, writeback, writethrough, directsync, unsafe, etc."
  type        = string
  default     = "none"
}

variable "vm_boot_wait" {
  description = "The number of seconds to wait before pressing Enter to boot to the ISO"
  type        = string
  default     = "11s"
}

# VM OS Vars
# specify configuration options for the Windows OS
variable "vm_os_computer_name" {
  description = "The computer name of the VM - must be 15 characters or less"
  type        = string
  default     = "srv22desktop"
}

variable "vm_os_administrator_password" {
  description = "The password for the local Administrator account"
  type        = string
  sensitive   = true
}

variable "vm_os_windows_image_name" {
  description = "The name of the Windows image to install - e.g. Windows Server 2022 SERVERSTANDARD"
  type        = string
  default     = "Windows Server 2022 SERVERSTANDARD"
}

variable "vm_os_windows_product_key" {
  description = "The Windows activation key to use - default is the KMS client setup key for Windows Server 2022 Standard provided by Microsoft"
  type        = string
  default     = "VDYBN-27WPP-V4HQT-9VMD4-VMK7H"
}

variable "vm_os_windows_owner_name" {
  description = "The owner of the Windows installation"
  type        = string
  default     = "Engineering Team"
}

variable "vm_os_organization_name" {
  description = "The organization of the Windows installation"
  type        = string
  default     = "Contoso"
}

variable "vm_os_time_zone" {
  description = "The time zone to configure on the VM - execute tzutil /l from a Windows command prompt to see available options"
  type        = string
  default     = "Pacific Standard Time"
}

variable "vm_os_locale" {
  description = "The language/locale to configure on the VM - execute dism /online /get-intl from a Windows command prompt to see available options"
  type        = string
  default     = "en-US"
}