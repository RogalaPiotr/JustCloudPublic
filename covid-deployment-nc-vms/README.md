# covid-deployment-nc-vms

If you want to help process data on COVID19, you can deploy this template on your subscription and take the next steps from the page. This template is only intended to help you implement a set of processing machines. More info here: https://foldingathome.org/covid19/

The template is building in the loop of resources:
1. VM
2. Managed disk
3. VNET (one)
4. Nic
5. Pubic IP
6. NSG (one for VNET)

## Create a covid-deployment-nc-vms


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FRogalaPiotr%2FJustCloudPublic%2Fmaster%2Fcovid-deployment-nc-vms%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/covid-deployment-nc-vms/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Command to deployment

```json
New-AzResourceGroup -ResourceGroupName covid19 -Location SouthCentralUS
New-AzResourceGroupDeployment -ResourceGroupName covid19 -TemplateURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/covid-deployment-nc-vms/azuredeploy.json" -adminUsername XXX -adminPassword XXX -numberOfInstances XXX -OS Ubuntu -SizeVM Standard_NC6_Promo
```

## Made by
Piotr Rogala
https://justcloud.pl
