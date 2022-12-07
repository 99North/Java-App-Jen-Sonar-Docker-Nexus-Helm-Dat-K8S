pipeline{
    agent any
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

        // stage('Docker Image Build and Push To Nexus Repo'){
        //     steps{
        //         script{

        //         }
        //     }
        // }
    }
}