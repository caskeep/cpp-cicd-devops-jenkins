pipeline {
    agent { label 'build' }
    stages {
        stage('Build') {
            steps {
                echo "Build" 
                sh "pwd && ls -ahl"
                sh 'rm -rf build && mkdir -p build && cd build && \
                    cmake -DCAMKE_BUILD_TYPE=Release .. && cmake --build .'
            }
        }
        stage('Test') {
            steps {
                echo "Test" 
                sh "pwd && ls -ahl"
                sh 'cd build && ./main'
            }
        }
        stage('Artifactory') {
            steps {
                sh "pwd && ls -ahl"
                rtUpload (
                    serverId: 'artifactory-cpp-t1',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "build/main",
                                "target": "generic-local/"
                            }
                        ]
                    }''',
                    buildName: 'holyFrog',
                    buildNumber: '42'
                )
            }
        }
        stage('Clean for next build') {
            steps {
                echo "cleanning" 
                sh "pwd && ls -ahl"
                sh 'git clean -dfx'
            }
        }
        stage('Build container building env') {
            steps {
                echo "Build container building env" 
                sh "pwd && ls -ahl"
                sh "docker build \
                    -t cpp-cicd-devops-jenkins:v${env.BUILD_ID} \
                    -t cpp-cicd-devops-jenkins:latest \
                    -f ./ci/build_env.dockerfile ."
            }
        }
        stage('Build with container') {
            steps {
                echo "Build with container" 
                sh "pwd && ls -ahl"
                sh "docker build \
                    -t cpp-cicd-devops-jenkins-artifact:v${env.BUILD_ID} \
                    -t cpp-cicd-devops-jenkins-artifact:latest \
                    -f ./ci/build_app.dockerfile ."
            }
        }
        stage('Test with container') {
            steps {
                echo "Test with container" 
                sh "pwd && ls -ahl"
                sh "docker run --rm cpp-cicd-devops-jenkins-artifact:v${env.BUILD_ID}"
            }
        }
        stage('Deploy to Production') {
            agent { label 'production' }
            steps {
                sh "pwd && ls -ahl"
                rtDownload (
                    serverId: 'artifactory-cpp-t1',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "generic-local/main",
                                "target": "build/"
                            }
                        ]
                    }''',
                    buildName: 'holyFrog',
                    buildNumber: '42'
                )
                sh "cd build && ./main"
            }
        }
    }
}

pipeline {
    agent any
    stages {
        stage("PipeLine2") {
            steps {
                echo "pipeline 2"
                sh "pwd && ls -ahl"
            }
        }
    }
}