pipeline{
    agent any
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    stages{
        stage('Sonar Quality Status Checking'){
            agent{
                docker{
                    image 'maven'
                }
            }
            steps{
                script{
                        withSonarQubeEnv(credentialsId: 'sonar-token') {
                                sh 'mvn clean package sonar:sonar'
                                 }
                }
            }
        }

        stage('Quality Gate Status'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }

        stage('Docker Build & Docker Push To Nexus Repo'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus-uname-pwd', variable: 'nexus')]) {
                        // here we use ${nexus} coz we dont want to see the nexus password to other
                            sh '''
                            docker build -t 44.195.38.176:8083/dockerhub:${VERSION} .
                            docker login  -u admin -p ${nexus} 44.195.38.176:8083
                            docker push 44.195.38.176:8083/dockerhub:${VERSION}
                            docker rmi  44.195.38.176:8083/dockerhub:${VERSION}
                            '''
                                    }
            }
                }
            }
        }

        
        post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "tinywinky9@gmail.com";  
		        }
	        }

        




    }

