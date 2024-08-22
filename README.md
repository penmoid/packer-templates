# Packer Templates

This repo contains IaC operating system image templates for use with [Packer](https://www.packer.io/) and [Proxmox](https://www.proxmox.com).  

## What is Packer

[Packer](https://www.packer.io/) is an open-source tool, created by [HashiCorp](https://www.hashicorp.com), for programmatically creating identical machine images. It allows you to automate the process of building and provisioning machine images, which can be used in cloud platforms like AWS/Azure, or in virtual machines. In my case, I use Packer to automate the creation of [Proxmox](https://www.proxmox.com) base image templates for my home lab.

## Templates
- [Windows Server 2019 Standard (Desktop Experience)](windows/server2019)
- [Windows Server 2022 Standard (Desktop Experience)](windows/server2022)

## Acknowledgements

These templates make use of third party code and libraries from:

- [umich-vci/packer-windows11-horizon](https://github.com/umich-vci/packer-windows11-horizon)
- [rgl/packer-plugin-windows-update](https://github.com/rgl/packer-plugin-windows-update)
- [bradlane/packer](https://github.com/bradlane/packer)
