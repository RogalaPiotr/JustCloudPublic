# simple-vm-index

Universal template with an index to deploying stamp servers in AV set. You can use this template for deployment windows and Linux before the select correct variable in OS.
I prepared this json's for needs Global Azure Bootcamp - inside you can find a small bug ;)

Option - 1
Resources:
1. VM
2. Manage disk
3. VNET
4. Availability Set
5. Network

Option - 2
Resources:
1. VM
2. Manage disk
3. VNET
4. Availability Set
5. Network
6. Public IP

## Create a new simple-vm-index instance's
Option - 1

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FRogalaPiotr%2FJustCloudPublic%2Fmaster%2Fsimple-vm-index%2Fazuredeploy-1.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-index/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

Option - 2

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FRogalaPiotr%2FJustCloudPublic%2Fmaster%2Fsimple-vm-index%2Fazuredeploy-2.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-index/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Variables
1. adminUsername
2. adminPassword
3. numberOfInstances
4. OS

## Command to deployment
Option - 1
```json
New-AzureRMResourceGroupDeployment -ResourceGroupName XXX -TemplateURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-index/azuredeploy-1.json" -adminUsername XXX -adminPassword XXX
```
Option - 2
```json
New-AzureRMResourceGroupDeployment -ResourceGroupName XXX -TemplateURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-index/azuredeploy-2.json" -adminUsername XXX -adminPassword XXX
```

## Modyfied by
Piotr Rogala
https://justcloud.pl
