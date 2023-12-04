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

                stage('Build') {
			agent {
                docker {
                    image 'mcr.microsoft.com/dotnet/sdk:7.0'
                    args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'echo passed'
                git branch: 'master', url: 'https://github.com/team4canarys/eShopOnWeb.git'
				sh 'dotnet build $WORKSPACE/Everything.sln'
                sh 'dotnet test $WORKSPACE/tests/UnitTests/UnitTests.csproj --collect:"Code coverage" '
                sh 'dotnet publish  $WORKSPACE/src/Web/Web.csproj --output $WORKSPACE/publish'
				archiveArtifacts 'publish/**'
				archiveArtifacts 'tests/UnitTests/TestResults/**/*.coverage'
            }
        }

                stage('Infra') {
            agent {
                docker {
                    image 'hashicorp/terraform:light'
                  
                }
            }
           
            steps {
                script {                   
                    // Continue with your Terraform initialization and deployment steps
                    git branch: 'master', url: 'https://github.com/team4canarys/eShopOnWeb.git'
                    sh 'ls -la $WORKSPACE/infra/TF' // List files in the directory for debugging
                    sh 'cd $WORKSPACE/infra/TF && terraform init'
                    sh 'cd $WORKSPACE/infra/TF && terraform plan'
                    sh 'cd $WORKSPACE/infra/TF && terraform apply -auto-approve'
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
                        sh "az webapp deployment source config-zip --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_WEBAPP_NAME --src $WORKSPACE/publish.zip"    
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        echo "Azure deployment failed: ${e.message}"
                    }
                }
            }
        }
    }
}
