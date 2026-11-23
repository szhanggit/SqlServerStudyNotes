$templateFile = "D:\Study\SqlServerStudyNotes\ADFStudyNotes\arm_template\ARMTemplateForFactory.json"
$parameterFile= "D:\Study\SqlServerStudyNotes\ADFStudyNotes\arm_template\ARMTemplateParametersForFactory.json"
$deploymentName = "ADFTestDeployment"
$tenantId = "4c1d9e0f-5c27-4228-a35a-de7b4083ff7b"
$subscriptionName = "ESG-DEV"
$resourceGroupName = "apd-aks-dev-rg"
$factoryName = "esg-txcloud-new-asse-adf-a"
$location = "Southeast Asia"
 
#Connect to Azure account
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionName
 
#Deploy Data Factory
New-AzResourceGroupDeployment `
  -Name $deploymentName `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile $templateFile `
  -TemplateParameterFile $parameterFile `
  -Tag @{"key1"="value1"; "key2"="value2";}
 
#Generate managed identity for Data Factory.
Set-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $factoryName -Location $location