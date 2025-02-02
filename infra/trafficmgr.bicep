targetScope = 'resourceGroup'

param environmentName string
param location string
param tags object

@description('Relative DNS profile name for the traffic manager profile, resulting FQDN will be <uniqueDnsName>.trafficmanager.net, and it must be globally unique.')
param uniqueDnsName string

var webAppNamePrefix = 'TMLabWebApp-${take(uniqueString(resourceGroup().id,subscription().subscriptionId),3)}-'
var webAppLocations = [
  'Central US'
  'Germany West Central'
  'UK West'
]
var webAppLocationSuffix = [
  'CentralUS'
  'germanywestcentral'
  'ukwest'
]
var appSvcPlanNamePrefix = 'TMLabAppSvcPlan'
var repoURL = 'https://github.com/pdtit/TrafficMgr'
var branch = 'master'



resource appSvcPlan 'Microsoft.Web/serverfarms@2020-12-01' = [
  for (item, i) in webAppLocations: {
    name: '${appSvcPlanNamePrefix}-${webAppLocationSuffix[i]}'
    location: item
    properties: {
      elasticScaleEnabled: 'false'
    }
    sku: {
      name: 'S1'
      tier: 'Free'
    }
    tags: tags
  }
]

resource webApp 'Microsoft.Web/sites@2022-03-01' = [
  for (item, i) in webAppLocations: {
    name: '${webAppNamePrefix}${webAppLocationSuffix[i]}'
    location: item
    properties: {
      serverFarmId: resourceId('Microsoft.Web/serverfarms', '${appSvcPlanNamePrefix}-${webAppLocationSuffix[i]}')
      httpsOnly: true
    }
    dependsOn: [
      appSvcPlan
    ]
    
    tags: tags
  }
]

resource webApp_SourceControl 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = [
  for i in range(0, length(webAppLocations)): {
    name: '${webAppNamePrefix}${webAppLocationSuffix[i]}/web'
    properties: {
      repoUrl: repoURL
      branch: branch
      isManualIntegration: true
    }
    dependsOn: [
      webApp
    ]
    tags: tags
  }
]

resource ExampleTMProfile 'Microsoft.Network/trafficManagerProfiles@2018-04-01' = {
  name: 'TMProfile-${environmentName}'
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Priority'
    dnsConfig: {
      relativeName: uniqueDnsName
      ttl: 30
    }
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/default.aspx'
    }
    tags: tags
  }
}

resource ExampleTMProfile_Endpoint 'Microsoft.Network/trafficManagerProfiles/azureEndpoints@2018-04-01' = [
  for i in range(0, length(webAppLocations)): {
    parent: ExampleTMProfile
    name: 'Endpoint${i}'
    location: 'global'
    properties: {
      targetResourceId: resourceId('Microsoft.Web/Sites/', '${webAppNamePrefix}${webAppLocationSuffix[i]}')
      endpointStatus: 'Enabled'
    }
    dependsOn: [
      webApp
    ]
    tags: tags
  }
]
