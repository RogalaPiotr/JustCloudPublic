<#
    .SYNOPSIS
        Script designed to set tags based on a CSV file for Resources.

    .DESCRIPTION
        Script designed to set tags based on a CSV file for Resources.

        Requirments:
        Powershell Core
        Module Azure Az

    .PARAMETER path,
        Not mandatory. Path where is CSV file. In Path script is taking last new CSV file where name include: *Resources.csv.

    .PARAMETER subId,
        Not mandatory. Subscription Id.

    .PARAMETER tenantId
        Not mandatory. Tenant Id.

    .EXAMPLE
        .\SetTagsResources.ps1
        .\SetTagsResources.ps1 -path 'c:/temp' -subId xxxxxxxx-xxxxx-xxxx-xxxx -tenantId xxxxxxxx-xxxxx-xxxx-xxxx

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

    if ($path) {
        $path = $path.trimEnd('\').trimEnd('/')
        if (Test-Path "${path}/*Resources.csv") {
            $FileResources = Get-ChildItem -Path $path -Filter *Resources.csv |  Sort-Object LastAccessTime -Descending | Select-Object -First 1
            Write-Host "CSV loaded: $($FileResources.PSPath)"

        }
        else {
            Write-Host "Wrong PATH! - please check your path for file: ${path}/*Resources.csv"
            exit
        }
    }
    else {
        $FileResources = Get-ChildItem -Path .\ -Filter *Resources.csv |  Sort-Object LastAccessTime -Descending | Select-Object -First 1
        Write-Host "CSV loaded: $($FileResources.PSPath)"
    }


    $csv = Import-Csv -Delimiter ";" -Path $FileResources.PSPath

    $csv | ForEach-Object -Parallel {
        function SetupTags($tag, $rsName, $rsType, $rgName) {
            Write-Output $($tag | Out-String)
            $null = Set-AzResource -ResourceName $rsName -ResourceGroupName $rgName -ResourceType $rsType -tag $tag -Force | Out-Null
        }
        function CleanUpTags($rsName, $rsType, $rgName) {
            Write-Output "`tCleaning tags"
            $null = Set-AzResource -ResourceName $rsName -ResourceGroupName $rgName -ResourceType $rsType -tag @{} -Force | Out-Null
        }
        $tag = @{}
        Write-Output $("Setting tags for Resource: " + $($_.'RESOURCE NAME') + " in Resource Group: " + $($_.'RESOURCE GROUP NAME'))
        foreach ($ResourceGroupName in $($_.'RESOURCE GROUP NAME')) {
            if ([string]::IsNullOrEmpty($_.'TAG - KEY')) {
                $null = CleanUpTags -rsName $($_.'RESOURCE NAME')  -rsType $($_.'RESOURCE TYPE') -rgName $($_.'RESOURCE GROUP NAME')
            }
            else {
                #One Tag
                if (($($_.'TAG - KEY') -split ',').Count -eq 1) {
                    $tag = @{$_.'TAG - KEY' = $_.'TAG - VALUE' }
                    $null = SetupTags -tag $tag -rsName $($_.'RESOURCE NAME')  -rsType $($_.'RESOURCE TYPE') -rgName $($_.'RESOURCE GROUP NAME')
                }
                #More than one Tag
                else {
                    $a = $($_.'TAG - KEY') -split ','
                    $b = $($_.'TAG - VALUE') -split ','
                    if ($a.Length -match $b.Length) {
                        for ($i = 0; $i -lt $a.Length; $i++) {
                            $tag += @{$($a[$i]) = $($b[$i]) }
                        }
                        $null = SetupTags -tag $tag -rsName $($_.'RESOURCE NAME')  -rsType $($_.'RESOURCE TYPE') -rgName $($_.'RESOURCE GROUP NAME')
                    }
                }
            }
        }
    } -ThrottleLimit 5
}