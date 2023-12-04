pipeline {
    agent any

    environment {
        AZURE_WEBAPP_NAME = 'eshoponweb-team4'
        AZURE_RESOURCE_GROUP = 'team4-dotnet'
        AZURE_PLAN_NAME = 'eshoponweb-plan'
        ARTIFACT_PATH = '$WORKSPACE/publish'
        AZURE_CREDENTIALS_ID = 'azurecred'
        AZURE_CLIENT_ID = 'c7f59d11-4e5e-4c7b-b25d-9093238144bc'
        AZURE_CLIENT_SECRET = 'e1Z8Q~KX~KcwRolI8vdiumoVJ8U4YNfqYo-XRbUi'
        AZURE_TENANT_ID = '0c88fa98-b222-4fd8-9414-559fa424ce64'
        AZURE_CONFIG_DIR = "$WORKSPACE/.azure"  // Set the Azure CLI configuration directory
    }
	
	stages {

                stage('Create Zip') {
           steps {
               script {
                   // Create a tarball from the contents of the publish directory
                   // sh "sudo zip -r $WORKSPACE/publish.zip $WORKSPACE/publish"
                   sh 'echo Jenkins@123 | sudo -S zip -r /var/lib/jenkins/workspace/eShopOnWeb/publish.zip /var/lib/jenkins/workspace/eShopOnWeb/publish'
                   //zip publish.zip -d publish
                }
             }
         }
                stage('DeployToAzureAppService') {
            agent {
                docker {
                    image 'mcr.microsoft.com/azure-cli'
                }
            }
            steps {
                script {
                    echo 'Deploying to Azure App Service'
                    try {
                        sh "export AZURE_CONFIG_DIR=$AZURE_CONFIG_DIR && az login --service-principal --username $AZURE_CLIENT_ID --password $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID"
                        // sh "az webapp deployment source config-zip --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_WEBAPP_NAME --src $WORKSPACE/artifacts.zip"
                        // sh "azureWebAppPublish credentialsId: env.AZURE_CREDENTIALS_ID, resourceGroup: env.AZURE_RESOURCE_GROUP, appName: env.AZURE_WEBAPP_NAME, package: [target: '$WORKSPACE/publish/**/*'], deploymentMethod: 'auto', deleteAppServiceOnFailure: true, enableForDeployment: false "
                        sh "az webapp deployment source config-zip --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_WEBAPP_NAME --src $WORKSPACE/publish"    
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        echo "Azure deployment failed: ${e.message}"
                    }
                }
            }
        }
    }
}
