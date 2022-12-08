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
                            docker build -t http://44.195.38.176:8083/dockerhub:${VERSION} .
                            docker login  -u admin -p ${nexus} 44.195.38.176:8083
                            docker push http://44.195.38.176:8083/dockerhub:${VERSION}
                            docker rmi  http://44.195.38.176:8083/dockerhub:${VERSION}
                            '''
                                    }
            }
                }
            }
        }

        




    }
