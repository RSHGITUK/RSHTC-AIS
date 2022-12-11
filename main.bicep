// Scope - deploying resouce group
targetScope = 'subscription'

// Reusable parameters
param org string
param location string
param locationShort string
param dateTime string = utcNow('d')

//tags
param tagOwner string
param environmentName string
param tagApplicationName string
param tagCostCenterName string
param resourceTags object = {
  Application: tagApplicationName
  CostCenter: tagCostCenterName
  CreationDate: dateTime
  Environment: environmentName
  Owner: tagOwner
}

// Environment specifics
var environmentSettings = {
  dev: {
    deployApiManagement: false
    apiManagementsku: 'Developer'
    apiManagementskuCount: 1
  }
  test: {
    deployApiManagement: false
    apiManagementsku: 'Developer'
    apiManagementskuCount: 1
  }
  production: {
    deployApiManagement: false
    apiManagementsku: 'Developer'
    apiManagementskuCount: 1
  }
}

// Resource Group
var resourceGroupName = '${org}-rg-${environmentName}-${locationShort}'

// LogicApp params and variables
var logicAppName = '${org}-logic-${environmentName}'

@description('Sample URL for LogicApp created above')
param logicAppTestUri string

resource createdResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
  tags: resourceTags
}

module logicApp './modules/logicapp/logicapp.bicep' = {
  scope: createdResourceGroup
  name: 'logicAppDeploy'
  params: {
    location: location
    logicAppName: logicAppName
    logicAppTestUri: logicAppTestUri
    resourceTags: resourceTags
  }
  dependsOn: [
    createdResourceGroup
  ]
}
