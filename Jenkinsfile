node {
    stage('Preparation') {
        if (env.BRANCH_NAME == 'master') {
            echo "on master branch, do master things."
        } else {
            echo "not on master branch, in ${env.BRANCH_NAME}, do feature things."
        }
        echo "test with static branch name env value ${feature_scripted}"
    }
    stage('Build') {
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
        sh ("cd build && tar -cf ${env.BRANCH_NAME}.tar.gz main")
        def server = Artifactory.server 'artifactory-cpp-t1'
        def uploadSpec = """{
            "files": [
                {
                    "pattern": "./build/${env.BRANCH_NAME}.tar.gz",
                    "target": "generic-local/"
                }
            ]
            }"""
        server.upload spec: uploadSpec
    }
}
