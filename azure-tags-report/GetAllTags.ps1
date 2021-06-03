<#
    .SYNOPSIS
        Script designed to download all resources and resource groups along with tags with azure. Script is generating two files: one for resources and second for resource groups.

    .DESCRIPTION
        Script designed to download all resources and resource groups along with tags with azure. Script is generating two files: one for resources and second for resource groups.

        Requirments:
        Powershell Core
        Module Azure Az

    .PARAMETER path,
        Not mandatory. Path where is CSV file. In Path script is taking last new CSV file where name include: *Resource-Group.csv.

    .PARAMETER subId,
        Not mandatory. Subscription Id.

    .PARAMETER tenantId
        Not mandatory. Tenant Id.

    .EXAMPLE
        .\GetAllTags.ps1
        .\GetAllTags.ps1 -path 'c:/temp' -subId xxxxxxxx-xxxxx-xxxx-xxxx -tenantId xxxxxxxx-xxxxx-xxxx-xxxx

    .NOTES
        Author:     Piotr Rogala
        Created:    24/05/2021
#>

param(
    [Parameter(Mandatory = $false)][string] $path,
    [Parameter(Mandatory = $false)][string] $subId,
    [Parameter(Mandatory = $false)][string] $tenantId
)

begin {
}

process {
    try {
        $tmp = (Get-AzContext).Environment.Name -like "AzureCloud" 2>$null
        if ($tmp) {
            Write-Host "You are logged to Azure!" -ForegroundColor Green
        }
        else {
            Write-Host "You have to loggin to Azure!" -ForegroundColor Yellow
            $null = Connect-AzAccount -Environment AzureCloud -Tenant $tenantId -Subscription $subId
        }
    }
    catch {
        Write-Host "You have to loggin to Azure!" -ForegroundColor Yellow
        $null = Connect-AzAccount -Environment AzureCloud -Tenant $tenantId -Subscription $subId
    }

    function removeExistingCSV {
        [CmdletBinding()]
        param (
            [Parameter()][string]$path
        )
        if (Test-Path $path) {
            Remove-Item $path -Force
        }
    }

    if ($path) {
        $path = $path.trimEnd('\').trimEnd('/')
        if (Test-Path $path) {
            #Set name files with path
            $GDate = Get-Date -format "yyyy-MM-dd"
            $FileResources = "${path}\${GDate}-Tags-Resources.csv"
            $FileResourceGroups = "${path}\${GDate}-Tags-Resource-Groups.csv"
        }
        else {
            Write-Host "Wrong PATH! - please check your path: ${path}"
            exit
        }
    }
    else {
        #Set name files without path
        $GDate = Get-Date -format "yyyy-MM-dd"
        $FileResources = "${GDate}-Tags-Resources.csv"
        $FileResourceGroups = "${GDate}-Tags-Resource-Groups.csv"
    }

    #Remove existing file with based on date
    try{
        removeExistingCSV -path $FileResources
        removeExistingCSV -path $FileResourceGroups
    }
    catch{
        $_
    }

    #Get Azure resources
    $allrs = Get-AzResource
    $allrg = Get-AzResourceGroup

    Write-Host "Founded $($allrs.count) resources"
    Write-Host "Founded $($allrg.count) resource groups"

    #Creating file and set the heading and generate CSV files
    Write-Host "Creating file: ${FileResources}"
    Write-Output "$('RESOURCE GROUP NAME')$(";")$('RESOURCE NAME')$(";")$('RESOURCE TYPE')$(";")$('TAG - KEY')$(";")$('TAG - VALUE')" | Out-File $FileResources -Append
    Write-Host "Creating file: ${FileResourceGroups}"
    Write-Output "$('RESOURCE GROUP NAME')$(";")$('ResourceId')$(";")$('TAG - KEY')$(";")$('TAG - VALUE')" | Out-File $FileResourceGroups -Append

    #Get all resources
    foreach ($allrss in $allrs) {
        Write-Host "reading resource: "$allrss.Name
        if ($allrss.Name -match "[\/().]" -or $allrss.Type -match "microsoft.insights/metricalerts") {
            #Probably it is not a resource for tagging
        }
        else {
            if ([string]::IsNullOrEmpty($allrss.Tags)) {
                Write-Output "$($allrss.ResourceGroupName)$(";")$($allrss.ResourceName)$(";")$($allrss.ResourceType)$(";")$("empty")" | Out-File $FileResources -Append
            }
            else {
                Write-Output "$($allrss.ResourceGroupName)$(";")$($allrss.ResourceName)$(";")$($allrss.ResourceType)$(";")$($allrss.Tags.Keys -join (','))$(";")$($allrss.Tags.Values -join (','))" | Out-File $FileResources -Append
            }
        }
    }

    #Get all resource groups
    foreach ($allrgg in $allrg) {
        Write-Host "reading resource group: "$allrgg.ResourceGroupName
        if ([string]::IsNullOrEmpty($allrgg.Tags)) {
            Write-Output "$($allrgg.ResourceGroupName)$(";")$($allrgg.ResourceId)$(";")$("empty")" | Out-File $FileResourceGroups -Append
        }
        else {
            Write-Output "$($allrgg.ResourceGroupName)$(";")$($allrgg.ResourceId)$(";")$($allrgg.Tags.Keys -join (','))$(";")$($allrgg.Tags.Values -join (','))" | Out-File $FileResourceGroups -Append
        }
    }
}