# Sourced from bradlane/packer/files/win/scripts/winrm_setup.ps1

# Make sure WinRM can't be connected to, so Packer doesn't connect too early
New-NetFirewallRule -DisplayName "WinRM (HTTP)" -Direction Inbound -LocalPort 5985 -Action Block -Protocol TCP -Profile Any
New-NetFirewallRule -DisplayName "WinRM (HTTPS)" -Direction Inbound -LocalPort 5986 -Action Block -Protocol TCP -Profile Any

# Set WinRM Configuration
Set-WSManInstance -ResourceURI WinRM/Config/Winrs -ValueSet @{MaxMemoryPerShellMB="0"}
Set-WSManInstance -ResourceURI WinRM/Config -ValueSet @{MaxTimeoutms="7200000"}
Set-WSManInstance -ResourceURI WinRM/Config/Service -ValueSet @{MaxConcurrentOperationsPerUser="12000"}
Set-WSManInstance -ResourceURI WinRM/Config/Service/Auth -ValueSet @{Basic = "true" } 

# Create Self-Signed Cert for WinRM Listener
$IP = (Get-NetIPAddress -InterfaceAlias "Ethernet*" -AddressFamily IPv4).IPAddress
$CertificateThumbprint = (New-SelfSignedCertificate -DnsName $env:COMPUTERNAME, $IP -CertStoreLocation "Cert:\LocalMachine\My").Thumbprint

# Enable HTTPS listener
$listener = @{
    ResourceURI = "winrm/config/Listener"
    SelectorSet = @{Address = "*"; Transport = "HTTPS" }
    ValueSet    = @{CertificateThumbprint = $CertificateThumbprint }
}
New-WSManInstance @listener

# Configure UAC to allow privilege elevation in remote shells
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$Setting = 'LocalAccountTokenFilterPolicy'
Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

#Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0


# Configure and restart the WinRM Service; Enable the required firewall exception
Stop-Service -Name WinRM
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM
Set-NetFirewallRule -DisplayName "WinRM (HTTP)"  -Action Allow
Set-NetFirewallRule -DisplayName "WinRM (HTTPS)" -Action Allow