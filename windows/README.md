# Windows Server 2022 Standard (Desktop Experience)

This folder contains code for the fully-automated creation of a base template to deploy Windows Server 2022 Standard (Desktop Experience). It will perform the following steps:

1. Create an ephemeral build VM in your Proxmox instance
2. Deploy Windows Server 2022 Standard (Desktop Experience)
3. Install the VirtIO drivers and guest agent
4. Enable WinRM for further provisioning
5. Apply all available Windows updates
6. [Sysprep](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation) the VM
7. Convert the VM to a Proxmox template

Once this process has been completed, you will be able to clone this template to create new Windows Server VMs that are up-to-date and contain the drivers required to interact with VirtIO devices.

## Prerequisites

To use this template, the following are required:

- Access to your Proxmox environment via HTTPS
- A [Proxmox API Token](https://pve.proxmox.com/wiki/Proxmox_VE_API#API_Tokens) with permissions to create and modify VMs
- Packer [(Installation Instructions)](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- A  Windows Server 2022 ISO [(download)](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022)
- The latest VirtIO drivers [(download)](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/?C=M;O=D)
- A supported CLI tool for generating ISO images from your build workstation:
  - Windows
    - oscdimg (Part of the [Windows ADK](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install))
  - Linux
    - xorriso
    - mkisofs
  - Mac
    - hdiutil
  - Note: This has been tested using WSL2 and mkisofs, YMMV with other platforms and tools

## How to Build

1. Clone or download this repo.
2. Review the [variables](vars.pkr.hcl) and their defaults. You must [assign all variables](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation) that either have no `default = value` provided or that you wish to override.
3. From this directory, initialize the build by running `packer init .`
4. After initialization completes, kick off the build by running `packer build .`

The build process takes about 20 minutes in my environment at the time of this writing, however this will vary based on a number of factors, such as:

- The specs of the Proxmox host
- The resources assigned to the ephemeral template VM
- The speed of the internet connection to the Proxmox host
- The number and size of available Windows Updates

Please feel free to reach out or [raise an issue](https://github.com/penmoid/packer-templates/issues) if you encounter problems.  
**Note**: Support is best effort and not guaranteed, etc.

## Known Issues

- The Packer Proxmox builder requires that two additional virtual CDROM drives be attached during the build (one containing VirtIO drivers, and one containing the unattended answer file along with the WinRM enablement script), however in its current iteration it does not remove or eject these devices after the build. You will need to manually remove them from the template after it is created.
