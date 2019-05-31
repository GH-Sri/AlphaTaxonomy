//@Library('shared-libs')
import groovy.transform.Field;
//import sevatec.GithubIssue;
//import sevatec.GithubStatus;

def worker_label = "worker-${UUID.randomUUID().toString()}"

@Field String orgName = 'gh-mdas'
@Field String gitCommit = null
def shortGitCommit = null
def containerImage  = "ghmdas/verse"
def previousGitCommit = null
@Field String buildUrl = null
def containerTag = null
@Field String gitUrl =''
def branch = 'master'
def sonarStatus = null

tag = ''
branchName = ''

podTemplate(name: 'kaniko', label: worker_label, yaml: """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /root
  - name: docker
    image: docker:18.06.1-ce-dind
    imagePullPolicy: Always
    command:
    - cat
    tty: true
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-io
          items:
            - key: .dockerconfigjson
              path: .docker/config.json
"""
  ) {

  node(worker_label) {
    stage('Prepare') {
        scmInfo = checkout scm
        echo "scm : ${scmInfo}"
        gitCommit = scmInfo.GIT_COMMIT
        shortGitCommit = gitCommit[0..10]
        previousGitCommit = scmInfo.GIT_PREVIOUS_COMMIT
        buildUrl = env.BUILD_URL
        containerTag = "${branch}-${shortGitCommit}"
        gitUrl = scmInfo.GIT_URL

        container('docker') {
            currentBuild.displayName = containerTag
            sh """
                echo "BUILD_URL=${buildUrl}"
                echo "GIT_COMMIT=${gitCommit}"
                echo "SHORT_GIT_COMMIT=${shortGitCommit}"
                docker -v
               
                
            """
        }

    }
    stage('Build with Kaniko') {
      //git 'https://github.com/jenkinsci/docker-jnlp-slave.git'
      container(name: 'kaniko', shell: '/busybox/sh') {
          sh """#!/busybox/sh
            /kaniko/executor -f `pwd`/dockerfiles/r-verse/Dockerfile --context `pwd` --destination docker.io/${containerImage}:${containerTag}
          """
      }
    }
  }
}
