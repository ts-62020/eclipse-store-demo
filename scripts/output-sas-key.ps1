
[CmdletBinding()]
param(
	[string] $Path = ".",
	[string] $FileName = "StorageAccountKey.txt"
)

$key = terraform output -raw storage_account_key

if ($key) {
	New-Item -Path $Path -Name $FileName -ItemType "file" -Value $key -Force
} else {
	throw "Key is empty"
}