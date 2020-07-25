pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                label 'build'
            }
            steps {
                echo "Build" 
                sh 'rm -rf build && mkdir -p build && cd build && \
                    cmake -DCAMKE_BUILD_TYPE=Release .. && cmake --build .'
            }
        }
        stage('Test') {
            agent {
                label 'build'
            }
            steps {
                echo "Test" 
                sh 'cd build && ./main'
            }
        }
        stage('Artifactory') {
            agent {
                label 'build'
            }
            steps {
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
        stage('Deploy to Production') {
            agent {
                label 'production'
            }
            steps {
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
            }
        }
        stage('Clean for next build') {
            steps {
                echo "cleanning" 
                sh 'git clean -dfx'
            }
        }
        stage('Build container building env') {
            steps {
                echo "Build container building env" 
                sh "docker build \
                    -t cpp-cicd-devops-jenkins:v${env.BUILD_ID} \
                    -t cpp-cicd-devops-jenkins:latest \
                    -f ./ci/build_env.dockerfile ."
            }
        }
        stage('Build with container') {
            steps {
                echo "Build with container" 
                sh "docker build \
                    -t cpp-cicd-devops-jenkins-artifact:v${env.BUILD_ID} \
                    -t cpp-cicd-devops-jenkins-artifact:latest \
                    -f ./ci/build_app.dockerfile ."
            }
        }
        stage('Test with container') {
            steps {
                echo "Test with container" 
                sh "docker run --rm cpp-cicd-devops-jenkins-artifact:v${env.BUILD_ID}"
            }
        }
    }
}