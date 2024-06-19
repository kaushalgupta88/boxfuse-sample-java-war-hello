pipeline {
    agent any
    
    tools {
        maven "Maven 3.9.6"
    }

    environment {
        image = "web-app"
        tag = getDockerTag()
        gitRepo = "https://github.com/kaushalgupta88/boxfuse-sample-java-war-hello.git"
        namespace = "dev"
        dockerRepo = "kaushalgupta88"
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
                sh "./substitute-script.sh ${env.dockerRepo}/${env.image}:${env.tag} pod-template.yaml > ${env.image}-pod.yaml"
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
        // stage('SSH Into k8s Server') {

        //     steps {
        //         script {
        //             def remote = [:]
        //             remote.name = 'master'
        //             remote.host = '192.168.1.27'
        //             remote.user = 'kaushal'
        //             remote.password = 'kaushal'
        //             remote.allowAnyHosts = true

        //             stage('Put yaml onto k8s master') {
        //                 sshPut remote: remote, from: 'web-app-pod.yaml', into: '.'
        //             }

        //             stage('Deploy yaml to k8s') {
        //                 sshCommand remote: remote, command: "kubectl apply -f ${env.image}-pod.yaml -n ${env.namespace}"
        //             }
        //         }
        //     }
        // }
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