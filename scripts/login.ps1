
[CmdletBinding()]
param(
	[guid] $TenantId = [guid]"0e17f90f-88a3-4f93-a5d7-cc847cff307e"
)

az login --scope https://graph.microsoft.com/.default --tenant $TenantId
