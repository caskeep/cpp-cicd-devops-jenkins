pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo "Build" 
                sh 'rm -rf build && mkdir -p build && cd build && \
                    cmake -DCAMKE_BUILD_TYPE=Release .. && cmake --build .'
            }
        }
        stage('Test') {
            steps {
                echo "Test" 
                sh 'cd build && ./main'
            }
        }
        stage('Artifactory') {
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