@Library('shared-libs')
import groovy.transform.Field;
import sevatec.GithubIssue;
import sevatec.GithubStatus;

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

def makeStatus(String stage, String status) {
  withCredentials([string(credentialsId: 'ghaccount-api-token', variable: 'TOKEN')]) {  
    GithubStatus githubStatus = new GithubStatus()
    githubStatus.setToken(TOKEN)
    githubStatus.setStatus(status)
    githubStatus.setDescription("${stage}:${status}")
    githubStatus.setStatusContext(stage)
    githubStatus.setGitCommit(GIT_COMMIT)
    githubStatus.setBuildUrl(BUILD_URL)
    githubStatus.createStatus()
  }
}

def makeIssue(String stage) {
  withCredentials([string(credentialsId: 'ghaccount-api-token', variable: 'TOKEN')]) {  
    GithubIssue githubIssue = new GithubIssue()
    githubIssue.setToken(TOKEN)
    githubIssue.setIssueBody("Error during ${stage}, see ${BUILD_URL}")
    githubIssue.setIssueTitle("${ghprbSourceBranch} ${stage} Failure")
    githubIssue.setAuthor([ghprbPullAuthorLogin])
    githubIssue.createIssue()
  }
}

def output(String stage, String status) {
  def slackColor = ''
  if (status == 'success') {
    slackColor = 'good'
  }
  else {
    slackColor = 'danger'
  }
  try {
    makeStatus(stage, status)
    if (status == 'failure'){
      makeIssue(stage)
      slackSend color: slackColor, message: "${ghprbPullTitle} Build ${env.BUILD_ID} ${status} during ${stage}. See ${env.BUILD_URL}"
    }
    else {
      slackSend color: slackColor, message: "${ghprbPullTitle} Build ${env.BUILD_ID} ${status} during ${stage}."
    }
  }
  catch(err) {
    println 'Issue communicating with Github'
  }
}

//TODO: Kept this but don't think it's needed for the pipelines
podTemplate (
  label: 'master',
  containers: [
    //containerTemplate(name: 'gradle', image: 'essoegis/gradle:5.4-sdk8-alpine',  resourceRequestMemory: '1024Mi', resourceLimitMemory: '2048Mi', command: 'cat', ttyEnabled: true, privileged: true),
    containerTemplate(name: 'docker', image: 'docker:18.06.1-ce-dind', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'kaniko', image: 'gcr.io/kaniko-project/executor:debug', command: '/busybox/cat', ttyEnabled: true),
    containerTemplate(name: 'jq', image: 'endeveit/docker-jq', command: 'cat', ttyEnabled: true)
  ],
  volumes: [
    //hostPathVolume(mountPath: '/home/jenkins', hostPath: '/tmp/jenkins/'),
    hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/tmp/jenkins/.gradle'),
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ]
)
pipeline {
  agent none
  environment {
    //TODO: fix these
    REGISTRY_URL      = ''
    DOCKER_IMAGE_NAME = 'alpine'
    NEXUS_IMAGE_NAME  = 'ghmdas/verse'
  }
  stages {
    stage('Pre-Build') {
      agent { label 'master' }
      steps {
        script {
          if (binding.hasVariable('ghprbSourceBranch')) {
            env.ghprbSourceBranch = env.GIT_BRANCH
          }
          sshagent(['ghaccount-key']) {
            sh 'git fetch'
          }
          sh "git checkout ${env.ghprbSourceBranch}"
          println "Keeping tag the same ${tag}"
          tag = "data.${env.ghprbSourceBranch}"
          env.VERSION = "${tag.trim()}.${BUILD_NUMBER}"
        
          sshagent(['ghaccount-key']) {
            sh 'git pull'
          }
        }
        echo "${env.VERSION}"
      }
    }
    stage('Build') {
      agent {
        docker {
          image 'gradle:4.10.2-jdk8'
          args '-w /home/gradle/project'
        }
      }
      steps {
        script {
          try { 
            sh """
            java -version
            gradle -v
            gradle clean assemble -PprojVersion=${env.VERSION}
            """
            output('Build', 'success')
          }
          catch(err) {
            output('Build', 'failure')
            throw err
          } 
        }
      }
    }
    stage('Quality Gate') {
      parallel {
        stage('Unit Tests') {
          agent {
            docker {
              image 'gradle:4.10.2-jdk8'
              args '-w /home/gradle/project'
            }
          }
          steps {
            script {
              try {
                sh "gradle test -PprojVersion=${env.VERSION}"
                output('Test', 'success')
              }
              catch(err) {
                output('Test', 'failure')
                throw err
              }
            }
          }
          post {
            always {
              echo 'Success'
              //junit "**/TEST-*.xml"
            }
          }
        }
        /*TODO: Setup sonar
        stage('SonarQube') {
          agent {
            docker {
              image 'gradle:4.10.2-jdk8'
              args '-w /home/gradle/project'
            }
          }
          steps {
            script {
              try {
                withCredentials([string(credentialsId: 'sonarqube-login-token', variable: 'TOKEN')]) {
                  sh "gradle sonarqube -Dsonar.java.binaries=build/classes -Dsonar.projectVersion=${env.VERSION} -Dsonar.host.url=http://sonarqube.sevatecdemo.com -Dsonar.login=${TOKEN}"
                }
                output('Sonarqube', 'success')
              }
              catch(err) {
                output('Sonarqube', 'failure')
                throw err
              }
            }
          }
          post {
            always {
              echo 'Finished SonarQube'
            }
          }
        }
        */
      }
    }
    stage('Container Build') {
      agent { label 'master' }
      steps {
        script {
          try {    
            dir("${WORKSPACE}/newrelic") {
              //TODO: Populate newrelic-token credential with token and check files into nexus
              withCredentials([string(credentialsId: 'newrelic-token', variable 'TOKEN')]) {
                ['jar', 'yml'].each { ext ->
                  echo "Grabbing newrelic.${ext}"
                  sh "touch newrelic.${ext}" //Adding dummy file as place holder
                  // sh "http://nexushost/repository/newrelic.${ext}"
                }
                //sh "sed -i '/license.*/license: ${newrelic-token}/' ./newrelic.yml"
              }
            }
            echo env.BUILD_ID
            sh "docker build -t ${env.DOCKER_IMAGE_NAME}:${env.VERSION} --build-arg JAR_FILE=build/libs/data-${env.VERSION}.jar --build-arg=NR_JAR=newrelic/newrelic.jar --build-arg=NR_YML=newrelic/newrelic.yml ."
            output('Container Build', 'success')
          }
          catch(err) {
            output('Container Build', 'failure')
            throw err
          }
        }
      }
    }
    /*TODO: Setup these integrations
    stage('Container Analysis') {
      agent { label 'master' }
      steps {
        parallel (
          "Twistlock" : {
            script {
              twistlockScan ca: '',
                cert: '',
                compliancePolicy: 'critical',
                dockerAddress: 'unix:///var/run/docker.sock',
                gracePeriodDays: 0,
                ignoreImageBuildTime: true,
                image: "${env.DOCKER_IMAGE_NAME}:${env.VERSION}",
                key: '',
                logLevel: 'true',
                policy: 'warn',
                requirePackageUpdate: false,
                timeout: 10

              twistlockPublish ca: '',
                cert: '',
                dockerAddress: 'unix:///var/run/docker.sock',
                ignoreImageBuildTime: true,
                image: "${env.DOCKER_IMAGE_NAME}:${env.VERSION}",
                key: '',
                logLevel: 'true',
                timeout: 10
            }
          },
          "Tag + Push" : {
            script {
              try {
                echo 'container tag + push'
                withCredentials([usernamePassword(credentialsId: 'nexus-login', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                  sh """
                  docker login ${env.REGISTRY_URL} -u $USER -p $PASS
                  docker tag ${env.DOCKER_IMAGE_NAME}:${env.VERSION} ${env.REGISTRY_URL}/${env.NEXUS_IMAGE_NAME}:${env.VERSION}
                  docker push ${env.REGISTRY_URL}/${env.NEXUS_IMAGE_NAME}:${env.VERSION}
                  """
                }
                output('Container Tag and Push', 'success')
              }
              catch(err) {
                output('Container Tag and Push', 'failure')
                throw err
              }
            }
          }
        )
      }
    }
    */
  }
}
