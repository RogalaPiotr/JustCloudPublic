param (
    [Parameter(Mandatory=$true)] [string] $url,
    [Parameter(Mandatory=$true)] [string] $urlvsts,
    [Parameter(Mandatory=$false)] [string] $auth,
    [Parameter(Mandatory=$true)] [string] $token,
    [Parameter(Mandatory=$false)] [string] $pool,
    [Parameter(Mandatory=$false)] [string] $agentname
)

if (!(Test-Path 'c:\temp')){mkdir 'c:\temp'}

$log | % {

$filename = $url.Split('/')[-1]
Invoke-WebRequest -Uri $url -OutFile "c:\temp\$filename"

if (!(Test-Path 'c:\agent')){mkdir 'c:\agent'}
cd 'c:\agent'
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\$filename", "$PWD")

.\config.cmd --unattended --url $urlvsts --auth $auth --token $token --pool $pool --agent $agentname --runAsService

} | Out-File 'c:\temp\vstsagent.log'