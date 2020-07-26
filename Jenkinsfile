pipeline {
    agent none
    stages {
        stage('Build') {
            angent { label 'build' }
            steps {
                echo "Build" 
                sh "pwd && ls -ahl"
                sh 'rm -rf build && mkdir -p build && cd build && \
                    cmake -DCAMKE_BUILD_TYPE=Release .. && cmake --build .'
            }
        }
        stage('Test') {
            angent { label 'build' }
            steps {
                echo "Test" 
                sh "pwd && ls -ahl"
                sh 'cd build && ./main'
            }
        }
        stage('Artifactory') {
            angent { label 'build' }
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
            angent { label 'build' }
            steps {
                echo "cleanning" 
                sh "pwd && ls -ahl"
                sh 'git clean -dfx'
            }
        }
        stage('Build container building env') {
            angent { label 'build' }
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
            angent { label 'build' }
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
            angent { label 'build' }
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
            }
        }
    }
}