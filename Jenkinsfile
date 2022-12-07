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
                        withSonarQubeEnv(credentialsId: 'sonar-token'){
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

        stage('Docker Image Build and Push To Nexus Repo'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus', variable: 'nexus_creds')]) {
                            //  here <docker build -t 3.235.67.253:8083/springapp:${VERSION} .> means it will go to particular repo so we give the ip address of nexus docker repo
                             sh '''
                                    
                                     docker build -t 3.235.67.253:8083/springapp:${VERSION} .
                                     docker login -u admin -p ${nexus_creds} 3.235.67.253:8083
                                     docker push 3.235.67.253:8083/springapp:${VERSION}
                                     docker rmi 3.235.67.253:8083/springapp:${VERSION}

                                '''
                                                }
                    

                }
            }
        }
    }
}