node {
    stage('Preparation') {
        if (env.BRANCH_NAME == 'master') {
            echo "on master branch, do master things."
        } else {
            echo "not on master branch, in ${env.BRANCH_NAME}, do feature things."
        }
    }
    stage('Build') {
        checkout scm
        echo "Start Build"
        sh ("pwd && ls -ahl")
        sh ("rm -rf build && mkdir -p build && cd build && cmake .. && cmake --build .")
    }
    stage('Test') {
        echo "Start Build"
        sh ("pwd && ls -ahl")
        sh ("cd build && ./main")
    }
    stage('UploadToArtifactory') {
        echo "Start upload to artifactory"
        sh ("pwd && ls -ahl")
        echo "Start package to ${env.BRANCH_NAME}.tar.gz file"
        sh ("cd build && tar -czvf ${env.BRANCH_NAME}.tar.gz main")
        def server = Artifactory.server 'artifactory-cpp-t1'
        def uploadSpec = """{
            "files": [
                {
                    "pattern": "./build/${env.BRANCH_NAME}.tar.gz",
                    "target": "generic-local/"
                }
            ]
            }"""
        server.upload spec: uploadSpec, failNoOp: true
    }
}

node("prodution") {
    stage('DeployToProdution') {
        if (env.BRANCH_NAME == 'master') {
            echo "on master branch, start deploy master branch to prodution environment"
        } else {
            echo "not on master branch, in ${env.BRANCH_NAME}, skip this build"
            currentBuild.result = "ABORTED"
            error('Stop')
        }
        echo "Start deploy to prodution"
        sh ("pwd && ls -ahl")
    }
    stage("DownloadFromArtifactory") {
        def server = Artifactory.server 'artifactory-cpp-t1'
        def downloadSpec = """{
            "files": [
                {
                    "pattern": "generic-local/master.tar.gz",
                    "target": ""
                }
            ]
            }"""
        server.download spec: downloadSpec, failNoOp: true
    }
    stage('StartApp') {
        echo "Start app"
        sh ("pwd && ls -ahl")
        sh ("tar -xzf master.tar.gz && rm master.tar.gz")
        sh ("./main")
    }
}
