# simple-vm-shutdown-on-time

Simple deplymennt virtual machine with Windows Server 2016 with managed disk. In VM section has been added modeule to auto shudown machine on 18:00 in time zone: W. Europe Standard Time.

## Create a new simple-vm-shutdown-on-time instance

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FRogalaPiotr%2FJustCloudPublic%2Fmaster%2Fsimple-vm-shutdown-on-time%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-shutdown-on-time/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Variables
1. adminUsername
2. adminPassword
3. vmName

## Command to deployment
```json
New-AzureRMResourceGroupDeployment -ResourceGroupName XXX -TemplateURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-shutdown-on-time/azuredeploy.json" -adminUsername XXX -adminPassword XXX -vmName XXX
```

## Author
Piotr Rogala
http://justcloud.pl
