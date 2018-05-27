# simple-vm-with-installation-vsts-agent

This deployment is deploying VM on which is installing automatically VSTS agent and adding this VM to VSTS agent pool. Is also shutting down automatically on 18:00 CET. During deployment you have to add imporntant data for yout VSTS Projetc.

## Create a new simple-vm-with-installation-vsts-agent instance

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-with-installation-vsts-agent/azuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-with-installation-vsts-agent/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Variables
1. adminUsername [User name]
2. adminPassword [Password for user]
3. dnsLabelPrefix (default set: generated based on ResourceGroup.Id) [Public DNS for connection RDP]
4. vmName [VM Name for resource]
5. urlvsts [URL for your VSTS project]
6. auth (default set: PAT) [Authentication method for your VSTS]
7. token [Security tokent for your VSTS]
8. pool (default set: default) [Pool name for agent in VSTS]
9. AccessIPNSG [Your local IP for NSG to alow you connection to VM]
10. tag [default set: "Project: VSTSAgent"]



## Command to deployment
```json
New-AzureRMResourceGroup -Name VSTS -Location westeurope 
New-AzureRMResourceGroupDeployment -ResourceGroupName VSTS -TemplateURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/simple-vm-with-installation-vsts-agent/azuredeploy.json" -Verbose
```

## Author
Piotr Rogala
http://justcloud.pl
