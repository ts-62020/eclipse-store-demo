
[CmdletBinding()]
param(
	[string] $Path = ".",
	[string] $FileName = "StorageAccountKey.properties",
	[string] $TerraformTemplatePath = "$PSScriptRoot/../terraform"
)

Push-Location -Path $TerraformTemplatePath

$key = terraform output -raw storage_account_key

Pop-Location

$fileContent = @"
storage-filesystem.azure.storage.credentials.type=shared-key
storage-filesystem.azure.storage.credentials.account-key=$key
"@

if ($key) {
	New-Item -Path $Path -Name $FileName -ItemType "file" -Value $fileContent -Force
} else {
	throw "Key is empty"
}