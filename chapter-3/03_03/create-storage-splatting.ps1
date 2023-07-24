[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $StorageAccountSuffix,

    [Parameter(Mandatory)]
    [string]
    $ResourceGroup,
    
    [Parameter(Mandatory)]
    [ValidateSet("uksouth", "northeurope", "westeurope")]
    [string]
    $Location
)

$params = @{
    Name                    = ("sasplatscr$($StorageAccountSuffix)").ToLower()
    ResourceGroupName       = $ResourceGroup
    Location                = $Location
    SkuName                 = "Standard_LRS"
    Kind                    = "StorageV2"
    MinimumTlsVersion       = "TLS1_2"
    PublicNetworkAccess     = "Disabled"
}

$storageAccount = New-AzStorageAccount @params