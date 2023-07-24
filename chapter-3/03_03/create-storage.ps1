$resourceGroup = "rg-03-03"
$location = "<location>"
$storageAccountName = "sa0303pwsh"

Connect-AzAccount

New-AzResourceGroup -Name $resourceGroup -Location $location

New-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageAccountName `
  -Location $location `
  -SkuName Standard_RAGRS `
  -Kind StorageV2

$account = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
$account | Get-Member
$account.PrimaryEntpoints
$account.SecondaryEndpoints
$account.Context.ConnectionString

Remove-AzStorageAccount -ResourceGroupName $resourceGroup `
  -Name $storageAccountName