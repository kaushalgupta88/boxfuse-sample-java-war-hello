pipeline {
    agent any
    
    tools {
        maven "Maven 3.9.6"
    }

    environment {
        image = "tomcat-app"
        tag = getDockerTag()
        gitRepo = "https://github.com/kaushalgupta88/boxfuse-sample-java-war-hello.git"
        namespace = "dev"
        dockerRepo = "kaushalgupta88"
        SONARQUBE_SERVER = 'SonarQubeServer'
        SONARQUBE_CREDENTIALS = 'squ_eb0f628882cb7fb1719fc26b0fa4741ea568e4fc'
        SONAR_HOST_URL = 'http://192.168.1.26:9000'
        SONAR_PROJECT_KEY = 'boxfuse'
        // sonarProjectKey = "your_project_key"
        // sonarHostUrl = "http://192.168.1.100:9000"
        // sonarTokenId = "SonarQube-Token"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git "${env.gitRepo}"
            }
        }
        stage('Maven Build') {
            steps {
                script {
                    sh "mvn clean package"
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=$SONAR_PROJECT_KEY -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONARQUBE_CREDENTIALS'
                }
            }
        }
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             withCredentials([string(credentialsId: env.sonarTokenId, variable: 'SONAR_TOKEN')]) {
        //                 sh """
        //                     mvn sonar:sonar \
        //                     -Dsonar.projectKey=${env.sonarProjectKey} \
        //                     -Dsonar.host.url=${env.sonarHostUrl} \
        //                     -Dsonar.login=${SONAR_TOKEN}
        //                 """
        //             }
        //         }
        //     }
        // }
        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 10, unit: 'MINUTES') {
        //             script {
        //                 def qg = waitForQualityGate()
        //                 echo "Quality Gate Status: ${qg.status}"
        //                 echo "Quality Gate Details: ${qg}"
        //                 if (qg.status != 'OK') {
        //                     error "Pipeline aborted due to quality gate failure: ${qg.status}"
        //                 }
        //             }
        //         }
        //     }
        // }
        
        stage('Docker build') {
            steps {
                script {
                    sh "docker build -t ${env.image}:${env.tag} ."
                }
            }
        }
        stage('Docker push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DockerHub-Credentials', passwordVariable: 'DockerHubPass', usernameVariable: 'DockerHubUser')]) {
                        sh "docker login -u ${DockerHubUser} -p ${DockerHubPass}"
                        sh "docker tag ${env.image}:${env.tag} ${env.dockerRepo}/${env.image}:${env.tag}"
                        sh "docker push ${env.dockerRepo}/${env.image}:${env.tag}"
                    }
                }
            }
        }
        stage('Image tag substitution') {
            steps {
                sh "chmod +x substitute-script.sh"
                sh "./substitute-script.sh ${env.dockerRepo}/${env.image}:${env.tag} ${env.image}-pod pod-template.yaml > ${env.image}-pod.yaml"
            }
        }
        // stage('deploy container locally') {
        //     steps {
        //         script {
        //             sh "docker rm -f webappcon || true'
        //             sh "docker run -d --name webappcon ${env.dockerRepo}/${env.image}:${env.tag} /bin/bash"
        //         }
        //     }
        // }
        stage('SSH into remote docker server') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhost-ssh', usernameVariable: 'SSH_USERNAME', passwordVariable: 'SSH_PASSWORD')]) {
                        def remote = [:]
                        remote.name = 'dockerhost'
                        remote.host = '192.168.1.26'
                        remote.user = "${SSH_USERNAME}"
                        remote.password = "${SSH_PASSWORD}"
                        remote.allowAnyHosts = true
                    
                        stage('deploy container to remote dcoker server') {
                            sshCommand remote: remote, command: "docker rm -f webappcon || true"
                            sshCommand remote: remote, command: "docker run -itd --name webappcon -p 8080:8080 ${env.dockerRepo}/${env.image}:${env.tag} /bin/bash"
                        }
                    }
                }
            }
        }
        stage('SSH Into k8s Server') {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'master'
                    remote.host = '192.168.1.27'
                    remote.user = 'kaushal'
                    remote.password = 'kaushal'
                    remote.allowAnyHosts = true

                    stage('Put yaml onto k8s master') {
                        sshPut remote: remote, from: "${env.image}-pod.yaml", into: '.'
                    }

                    stage('Deploy yaml to k8s') {
                        sshCommand remote: remote, command: "kubectl apply -f ${env.image}-pod.yaml -n ${env.namespace}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'build successful!'
        }
        failure {
            echo 'build failed!'
        }
    }
}

def getDockerTag(){
    def tag = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
    return tag.take(8)
}
