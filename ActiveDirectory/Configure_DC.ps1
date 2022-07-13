<#
Author: Nickolaus Vendel
Date: 12-3-21
Revision: 1
Notes: This is for building domain controllers
#>

<# improvement section
#todo make variables a "fill out form"
#todo wrappers checks for installation idempotency
#>


#################
#region Variables
#################

#Hostname information
$dc_name="dc01"

#Local box Network settings
$dc_ip_address="192.168.50.10"


#DHCP network settings
$default_gateway="192.168.50.1"
$final_ip_range="192.168.50.254"
$subnet_mask="255.255.255.0"
$ScopeID="192.168.50.0"
$dhcp_end_reserve_range="192.168.50.15"

#Domain settings
$domain_forest_domain_name="domain"
$domain_forest_name="$domain_forest_domain_name.company.com"
$dc_path_1="COMPANY"

#OU Information
$pc_ou="WorkstationSystems"
$users_ou="UserAccounts"

####################
#endregion Variables
####################

#################
#region Execution
#################

#Preliminary Items
#Change hostname
if ($env:ComputerName -notlike $dc_name ){
    rename-computer -newname $dc_name
    restart-computer
}else{
    write-output "Hostname already set"
    
}

##########################
#Set Primary NIC Settings#
##########################

#Sets primary
#todo write section to get this part automated on the new nics with 1-2 piece for the fiber connections
<#
$IPType = "IPv4"
# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
# Configure the IP address and default gateway
#>

New-NetIPAddress –IPAddress $dc_ip_address -DefaultGateway $default_gateway -PrefixLength 24 -InterfaceIndex 2


####################
#Install DC feature#
####################

#Installs the role
install-windowsfeature -name AD-domain-services -includemanagementtools

#Configure forest name - and installs DNS
Install-ADDSForest -DomainName $domain_forest_name -DomainNetBIOSName $domain_forest_domain_name -InstallDNS

#Create PC OU - to be able to apply GPO
New-ADOrganizationalUnit -Name $pc_ou -Path "DC=$dc_path_1,DC=COM" -ProtectedFromAccidentalDeletion $False

#Create Users OU - to be able to apply GPO
New-ADOrganizationalUnit -Name $users_ou -Path "DC=$dc_path_1,DC=COM" -ProtectedFromAccidentalDeletion $False

############################
#Install and configure DHCP#
############################

#Installation
Install-WindowsFeature -name DHCP -IncludeManagementTools

#Configuration
Add-DhcpServerv4Scope -name $domain_forest_domain_name -StartRange $default_gateway -EndRange $final_ip_range -SubnetMask $subnet_mask -State Active
Add-DhcpServerv4ExclusionRange -ScopeID $ScopeID -StartRange $default_gateway -EndRange $dhcp_end_reserve_range
Set-DhcpServerv4OptionValue -OptionID 3 -Value $default_gateway -ScopeID $ScopeID -ComputerName $dc_name
Set-DhcpServerv4OptionValue -DnsDomain $domain_forest_name -DnsServer $dc_ip_address

#####################
#endregion Execution#
#####################

##############################
#region Promote additional DC#
##############################

#Promote DC code (for additional DC's only)
## Flag check for if domain exists already to join then promote

#################################
#endregion Promote additional DC#
#################################