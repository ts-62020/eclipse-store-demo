[CmdletBinding(DefaultParameterSetName = "CreateTfState")]
param(
	# Application Context Name
	[Parameter(Mandatory, ParameterSetName = "CreateTfState")]
	[string] $ApplicationName,

	# Azure Subscription
	[Parameter(ParameterSetName = "CreateTfState")]
	[Parameter(ParameterSetName = "ExistingTfState")]
	[string] $SubscriptionId = "010423ef-a703-47ef-bc5c-39d6e3b99d3a",

	# Resource Group for Terraform State
	[Parameter(ParameterSetName = "CreateTfState")]
	[string] $ResourceGroup = [string]::Empty,

	# Storage Account Name for Terraform State
	[Parameter(ParameterSetName = "CreateTfState")]
	[string] $StorageAccount = [string]::Empty,

	# Container Name for Terraform State
	[Parameter(ParameterSetName = "CreateTfState")]
	[string] $Container = [string]::Empty,

	# Location for Terraform State
	[Parameter(ParameterSetName = "CreateTfState")]
	[string] $Location = "westeurope",

	# Location for Backend Configuration File
	[Parameter(Mandatory, ParameterSetName = "ExistingTfState")]
	[string] $BackendConfigFile = [string]::Empty,

	# Stage label
	[Parameter(ParameterSetName = "CreateTfState")]
	[string] $Stage = "demo"
)

if ($BackendConfigFile) {
	if (-not (Test-Path -PathType Leaf -Path $BackendConfigFile)) {
		throw "The file '$BackendConfigFile' does not exist"
	} else {
		terraform init --backend-config=$BackendConfigFile
	}
} else {
	$prefix = "$($ApplicationName -replace "\W")-$Stage".ToLower()

	if ([string]::IsNullOrWhiteSpace($ResourceGroup)) {
		$rg = "$prefix-tfstate-rg"
	} else {
		$rg = $ResourceGroup
	}
	
	if ([string]::IsNullOrWhiteSpace($StorageAccount)) {
		$sa = "tfstate$((Get-Date -Format o) -replace "\W")".Substring(0, 24).ToLower()
	} else {
		$sa = $StorageAccount.ToLower()
	}
	
	if ([string]::IsNullOrWhiteSpace($Container)) {
		$sc = "$prefix-tfstate"
	} else {
		$sc = $Container
	}
	
	$cfgFile = "./$prefix.terraform-state.hcl"

	if (-not (az group show --name $rg --subscription $SubscriptionId)) {
		if ((Read-Host "Resource Group does not exist. Do you want to create '$rg'? (y/n)") -eq 'y') {
			az group create --location $Location --name $rg --subscription $SubscriptionId
		} else {
			throw "Aborted"
		}
	}
	
	if (-not (az storage account show --name $sa --resource-group $rg --subscription $SubscriptionId)) {
		if ((Read-Host "Storage Account does not exist. Do you want to create '$sa'? (y/n)") -eq 'y') {
			az storage account create `
				--name $sa `
				--subscription $SubscriptionId `
				--resource-group $rg `
				--location $Location `
				--access-tier Cool `
				--https-only true `
				--kind StorageV2 `
				--sku Standard_LRS
		} else {
			throw "Aborted"
		}
	}
	
	if (-not (az storage container show --name $sc --account-name $sa)) {
		if ((Read-Host "Storage Container does not exist. Do you want to create '$sc'? (y/n)") -eq 'y') {
			az storage container create --name $sc --account-name $sa
		} else {
			throw "Aborted"
		}
	}

@"
storage_account_name = $sa
container_name = $sc
resource_group_name  = $rg
"@ > $cfgFile

	terraform init --backend-config=$BackendConfigFile
}
