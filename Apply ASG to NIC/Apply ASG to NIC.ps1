# description: Add one or many Application Security Groups to a Network Interface of a VM.
# tags: Preview
<#
Notes:
This script assigns one or more Application Security Groups to a VM. It searches for the application security group of a segment or the whole name defined in a tag.
In order for this script to work, the ApplicationSecurityGroups custom tag must be filled with a comma-separated list with the names or parts of the names of the Application Security Groups (must be unique).
If the tag should not be called ApplicationSecurityGroups, then you must change this in the variable.
The whole system is subject to all the constraints and requirements that Application Security Groups bring with them. For example, only Application Security Groups from the same region can be assigned in the same subscription.

Requires:
- Application Security Groups
- A Tag with a part, or the whole name of one or many Application Security Groups

Author:
Stefan Beckmann
stefan@beckmann.ch
@alphasteff
https://github.com/alphasteff
#>

# Defines the name of the tag
$tagName = 'ApplicationSecurityGroups'

# Set Error action
$errorActionPreference = "Stop"

# Ensure context is using correct subscription
$azureContext = Set-AzContext -SubscriptionId $AzureSubscriptionId -ErrorAction Stop

# Get the VM and reads out the tag
$azVM = Get-AzVM -Name $AzureVMName -ResourceGroupName $AzureResourceGroupName
$tagValue = $azVM.Tags.$tagName

# Create an array with the names of the Application Security Groups
If (($null -ne $tagValue) -and ($tagValue -ne '')){
  [array]$asgNames = $tagValue.Split(',').Trim()
  $asgNames = $asgNames | Where-Object {$_}
} Else {
  [array]$asgNames = @()
}

# Loop through the defined Application Security Groups names
foreach ($asgAdd in $asgNames) {
  # Get the Network Interface
  $networkInterface = Get-AzNetworkInterface -ResourceId $azVM.NetworkProfile.NetworkInterfaces[0].Id
  Write-Verbose -Message ('NetworkInterface: ' + ($networkInterface | Out-String))

  # Get the Application Security Group
  $asg = Get-AzApplicationSecurityGroup | Where-Object {$_.Name.ToLower() -like ("*$asgAdd*").ToLower()}
  Write-Verbose -Message ('Asg: ' + ($asg | Out-String))

  # If the Application Security Group is found and the name also contains the part from the tag, the script will continue to run
  if ($asg.Name -match $asgAdd) {
    Write-Verbose -Message ('AddNicToAsg: ' + ($asg.Name))

    # Check whether application security groups have already been assigned and add the new application security group or add to the existing ones
    $applicationSecurityGroups = $networkInterface.IpConfigurations[0].'ApplicationSecurityGroups'
    If ($applicationSecurityGroups.id -contains $Asg.Id)
    {
      Write-Verbose -Message ('Appllication Security Group ' + $asg.Name + ' exists on NIC ' + $networkInterface.Name)
    }
    Else
    {
      If ($applicationSecurityGroups.Count -gt 0){
        $networkInterface.IpConfigurations[0].'ApplicationSecurityGroups' += $asg
      } Else {
        $networkInterface.IpConfigurations[0].'ApplicationSecurityGroups' = $asg
      }
      # Write the new list of Application Security Groups to the Network Interface
      $result = $networkInterface | Set-AzNetworkInterface
      Write-Verbose -Message ('NicToAsgAdded: ' + ($result | Out-String))
      Write-Output ('Appllication Security Group ' + $asg.Name + ' added to NIC ' + $networkInterface.Name)
    }
  } else {
    Write-Warning -Message ('AsgDoesNotExist: ' + ($asgAdd))
  }
}
