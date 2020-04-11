# covid-deployment-nc-vms

If you want to help to process data on COVID19 you can deploy this template on your subscription.
More info here: https://foldingathome.org/covid19/

The template is building in the loop:
Resources:
1. VM
2. Managed disk
3. VNET (one)
4. Nic
5. Pubic IP
6. NSG (one for VNET)

## Create a covid-deployment-nc-vms


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FRogalaPiotr%2FJustCloudPublic%2Fmaster%2Fcovid-deployment-nc-vms%2Fcovid-azuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/covid-deployment-nc-vms/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Command to deployment

```json
New-AzResourceGroup -ResourceGroupName covid19 -Location SouthCentralUS
New-AzResourceGroupDeployment -ResourceGroupName covid19 -TemplateURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/covid-deployment-nc-vms/covid-azuredeploy.json" TemplateParameterURI "https://raw.githubusercontent.com/RogalaPiotr/JustCloudPublic/master/covid-deployment-nc-vms/covid-azuredeploy.json
```

## Made by
Piotr Rogala
https://justcloud.pl
