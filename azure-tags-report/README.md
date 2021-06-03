# azure-tags-report

Once, I prepared this script to quickly tag many resources deployed on the Microsoft Azure platform. There are many ways to do it quickly and easily, but I tried to make a universal solution that is easy and safe to use. Therefore, I decided to make one script that generates all resources to a CSV file. And the second script based on the CSV file will pull resource data from it and overwrite it on the platform.

You can customize the script to suit your purpose so that it runs on multiple subscriptions, for example. There are many customization options for this script that I have intentionally left out. The scripts work modularly, so they can be easily used with another script, and the rest will be prepared and implemented based on the input data from the file.

* GetAllTags
  * The file is saved automatically to the location where we execute the script or we can use the -path option where the files are to be saved.
  * The file name includes the date, if the file exists it will be overwritten.
  * The script checks if you are logged in to Azure. When executing the script, you can specify the -tenantId parameter to make sure that you are logging into the appropriate Azure Directory, and -subId for selecting the correct subscription.
* SetTagsResourceGroups and SetTagsResources
  * Data from files is imported automatically based on the naming convention of the previously generated file. The script imports the latest CSV file in the specified directory. There is a path specified via the -path parameter.
  * Tags should be separated by commas.
  * The tags saved in the CSV file work as "Key: Value" pairs in separate columns.
  * The script gets all the items from the CSV file. The script then removes the tags in Microsoft Azure then entered from the CSV file.
  * If you do not want to move a given resource, just remove it from the CSV file.
  * The script runs in parallel mode, which allows you to make changes faster. Throttle for writing tags is 5, keep in mind this is the optimal value.
  * The script checks if you are logged in to Azure. You can specify the -tenant parameter when executing a script.
  * If you want to clear tags on resources, just leave an empty cell or enter "empty".
  * We can test the introduction of tags by entering only the resource that we want to change in the CSV file. The rest of the resources will not be considered when implementing tags.

## Command to use scripts

```powershell
#Get all tags from Azure
/GetAllTags.ps1 `
    -path '/tags/' `
    -subId 'YOUR_SUBSCRIPTION_ID' `
    -tenantId 'YOUR_TENANT_ID'

#Set tags for Resource Groups
/SetTagsResourceGroups.ps1 `
    -path '/tags/' `
    -subId 'YOUR_SUBSCRIPTION_ID' `
    -tenantId 'YOUR_TENANT_ID'

#Set tags for Resources
/SetTagsResources.ps1 `
    -path '/tags/' `
    -subId 'YOUR_SUBSCRIPTION_ID' `
    -tenantId 'YOUR_TENANT_ID'
```

## Made by
Piotr Rogala
https://justcloud.pl
