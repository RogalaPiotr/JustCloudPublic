Function Install-AzureDevOpsAgents{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string] $url,
        [Parameter(Mandatory=$true)][string] $urlvsts,
        [Parameter(Mandatory=$false)][string] $auth,
        [Parameter(Mandatory=$true)][string] $token,
        [Parameter(Mandatory=$false)][string] $pool = "default",
        [Parameter(Mandatory=$false)][string] $agentname,
        [Parameter(Mandatory=$false)][ValidateRange(1,20)][int] $numberagents = 1,
        [Parameter(Mandatory=$false)][bool] $installpowershellaz = $true
        )
        begin {
        }
        process { 
                try {

                    # Creating Pool in Azure DevOps
                    $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes( ":$token"))
                    $body = "{name:`"$pool`", autoProvision: `"true`"}"
                    if (!($pool -match "default" -or $pool -match "Azure Pipelines" -or $((Invoke-WebRequest -Method GET -Uri "$urlvsts/_apis/distributedtask/pools?api-version=5.1" -UseBasicParsing -Headers @{Authorization = "Basic $encodedPat"}).content | ? { $_ -like "*$pool*"}))){
                        $tmp = $(Invoke-WebRequest -Method POST -Uri "$urlvsts/_apis/distributedtask/pools?api-version=5.0-preview.1" -UseBasicParsing -Headers @{Authorization = "Basic $encodedPat"} -Body $body -ContentType "application/json") 2>$null
                    }

                    # Install agenets
                    $filename = $url.Split('/')[-1]
                    if (!(Test-Path "c:\temp")){mkdir "c:\temp"}
                    if (!(Test-Path "c:\temp\$filename")){Invoke-WebRequest -Uri $url -OutFile "c:\temp\$filename"}

                    for ($i=1; $i -le $numberagents; $i++) {

                        if (!(Test-Path "c:\agent-$i")){mkdir "c:\agent-$i"}else{rm c:\agent-$i -recurse -force; mkdir "c:\agent-$i"}
                        Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\$filename", "c:\agent-$i")
                        ."c:\agent-$i\config.cmd" --unattended --url $urlvsts --auth $auth --token $token --pool $pool --agent "$agentname-$i" --runAsService
                    }

                    # Install PowerShell module
                    if ($installpowershellaz){
                        try{
                            Install-PackageProvider -Name "Nuget" -Force
                        }
                        catch {
                            throw $_ 
                            break
                        }
                        try {
                            Install-Module -Name Az -Force
                        }
                        catch {
                            throw $_ 
                            break
                        }
                    }
                }
                catch {
                    throw $_ 
                    break
                }
        Write-Verbose "Successfully installed Azure DevOps Job Agents"
    }
}

