<# Module Function ready
Function Install-AzureDevOpsAgents{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string] $url,
        [Parameter(Mandatory=$true)][string] $urlvsts,
        [Parameter(Mandatory=$false)][string] $auth,
        [Parameter(Mandatory=$true)][string] $token,
        [Parameter(Mandatory=$false)][string] $pool,
        [Parameter(Mandatory=$false)][string] $agentname,
        [Parameter(Mandatory=$false)][ValidateRange(1,20)][string] $numberagents = 1
        )
        begin {
        }
        process { 
            try {
                for ($i=0; $i -le $numberagents; $i++) {
                
                    $log | % {
                    $filename = $url.Split('/')[-1]
                    Invoke-WebRequest -Uri $url -OutFile "c:\temp\$filename"
                    if (!(Test-Path "c:\agent-$i")){mkdir "c:\agent-$i"}
                    cd "c:\agent-$i"
                    Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\$filename", "$PWD")
                    .\config.cmd --unattended --url $urlvsts --auth $auth --token $token --pool $pool --agent "$agentname-$i" --runAsService
                    } | Out-File 'c:\temp\agantsinstallation.log' -Append

        }
    }
    catch {
        throw $_ 
        break
    }
    Write-Verbose "Successfully installed Azure DevOps Job Agents"
    }
}

#>

param(
    [Parameter(Mandatory=$true)][string] $url,
    [Parameter(Mandatory=$true)][string] $urlvsts,
    [Parameter(Mandatory=$false)][string] $auth,
    [Parameter(Mandatory=$true)][string] $token,
    [Parameter(Mandatory=$false)][string] $pool,
    [Parameter(Mandatory=$false)][string] $agentname,
    [Parameter(Mandatory=$false)][ValidateRange(1,20)][string] $numberagents = 1
    )
    begin {
    }
    process { 
        try {
            for ($i=0; $i -le $numberagents; $i++) {
            
                $log | % {
                $filename = $url.Split('/')[-1]
                Invoke-WebRequest -Uri $url -OutFile "c:\temp\$filename"
                if (!(Test-Path "c:\agent-$i")){mkdir "c:\agent-$i"}
                cd "c:\agent-$i"
                Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\$filename", "$PWD")
                .\config.cmd --unattended --url $urlvsts --auth $auth --token $token --pool $pool --agent "$agentname-$i" --runAsService
                } | Out-File 'c:\temp\agantsinstallation.log' -Append

    }
}
catch {
    throw $_ 
    break
}

Write-Verbose "Successfully installed Azure DevOps Job Agents"

}