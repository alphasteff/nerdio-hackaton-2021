# description: Add one or many Application Security Groups to a Network Interface of a VM.
# tags: Preview
<#
Notes:
In order for this runbook to work, the ApplicationSecurityGroups custom tag must be filled with a comma-separated list with the names or parts of the names of the Application Security Groups (must be unique).

Requires:
- Application Security Groups
- A Tag with a part, or the whole name of one or many Application Security Groups

Author:
Stefan Beckmann
stefan@beckmann.ch
@alphasteff
https://github.com/alphasteff
#>

# Set Error action
$ErrorActionPreference = "Stop"

# Ensure context is using correct subscription
Set-AzContext -SubscriptionId $AzureSubscriptionId

# Defines the name of the tag
$TagName = 'ApplicationSecurityGroups'

# Get the VM and reads out the tag
$AzVM = Get-AzVM -Name $AzureVMName -ResourceGroupName $AzureResourceGroupName
$ApplicationSecurityGroups = $AzVM.Tags.$TagName

# Create an array with the names of the Application Security Groups
If (($null -ne $ApplicationSecurityGroups) -and ($ApplicationSecurityGroups -ne '')){
  [array]$AsgNames = $ApplicationSecurityGroups.Split(',').Trim()
  $AsgNames = $AsgNames | Where-Object {$_}
} Else {
  [array]$AsgNames = @()
}

# Loop through the defined Application Security Groups names
foreach ($AsgAdd in $AsgNames) {
  # Get the Network Interface
  $NetworkInterface = Get-AzNetworkInterface -ResourceId $AzVM.NetworkProfile.NetworkInterfaces[0].Id
  Write-Verbose -Message ('NetworkInterface: ' + ($NetworkInterface | Out-String))

  # Get the Application Security Group
  $Asg = Get-AzApplicationSecurityGroup | Where-Object {$_.Name.ToLower() -like ("*$AsgAdd*").ToLower()}
  Write-Verbose -Message ('Asg: ' + ($Asg | Out-String))

  # If the Application Security Group is found and the name also contains the part from the tag, the script will continue to run
  if ($Asg.Name -match $AsgAdd) {
    Write-Verbose -Message ('AddNicToAsg: ' + ($Asg.Name))

    # Check whether application security groups have already been assigned and add the new application security group or add to the existing ones
    If ($NetworkInterface.IpConfigurations[0].$TagName.Count -gt 0){
      $NetworkInterface.IpConfigurations[0].$TagName += $Asg
    } Else {
      $NetworkInterface.IpConfigurations[0].$TagName = $Asg
    }

    # Write the new list of Application Security Groups to the Network Interface
    $Result = $NetworkInterface | Set-AzNetworkInterface
    Write-Verbose -Message ('NicToAsgAdded: ' + ($Result | Out-String))
    Write-Output ('Appllication Security Group ' + $Asg.Name + ' added to NIC ' + $NetworkInterface.Name)
  } else {
    Write-Warning -Message ('AsgDoesNotExist: ' + ($AsgAdd))
  }
}
