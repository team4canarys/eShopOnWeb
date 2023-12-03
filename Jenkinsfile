pipeline {
    agent none
	
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
                    args '--entrypoint=/usr/bin/env -e PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
                  
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
    }
}
