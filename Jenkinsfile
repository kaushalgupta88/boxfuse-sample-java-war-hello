pipeline {
    agent any
    
    tools {
        maven "Maven 3.9.6"
    }

    environment {
        image = "web-app"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git "https://github.com/kaushalgupta88/boxfuse-sample-java-war-hello.git"
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
                    sh "docker build -t ${env.image}:v1 ."
                }
            }
        }
        stage('Docker push') {
            steps {
                script {
                    sh "docker login -u kaushalgupta88 -p DockerHub7803"
                    sh "docker tag ${env.image}:v1 kaushalgupta88/${env.image}:v1"
                    sh "docker push kaushalgupta88/${env.image}:v1"
                }
            }
        }
        stage('Image tag substitution') {
            steps {
                sh "chmod +x substitute-script.sh"
                sh "./substitute-script.sh kaushalgupta88/${env.image}:v1 pod-template.yaml > web-app-pod.yaml"
            }
        }
        // stage('deploy container locally') {
        //     steps {
        //         script {
        //             sh "docker rm -f webappcon || true'
        //             sh "docker run -d --name webappcon kaushalgupta88/${env.image}:v1 /bin/bash"
        //         }
        //     }
        // }
        stage('SSH into remote docker server') {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'dockerhost'
                    remote.host = '192.168.1.26'
                    remote.user = 'root'
                    remote.password = 'root'
                    remote.allowAnyHosts = true
                    
                    stage('deploy container to remote dcoker server') {
                        sshCommand remote: remote, command: "docker rm -f webappcon || true"
                        sshCommand remote: remote, command: "docker run -itd --name webappcon -p 8080:8080 kaushalgupta88/${env.image}:v1 /bin/bash"
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
        //                 sshCommand remote: remote, command: "kubectl apply -f web-app-pod.yaml -n dev"
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