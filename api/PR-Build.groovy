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

pipeline {
  agent none
  environment {
    //TODO: fix these
    REGISTRY_URL      = ''
    DOCKER_IMAGE_NAME = 'ghmdas'
    NEXUS_IMAGE_NAME  = 'ghmdas/verse'
  }
  stages {
    stage('Pre-Build') {
      agent none
      steps {
        script {
          tag = "data.${env.ghprbSourceBranch}"
          env.VERSION = "${tag.trim()}.${BUILD_NUMBER}"
          echo "${env.VERSION}"
        }
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
      }
    }
    stage('Container Build') {
      agent { label 'master' }
      steps {
        script {
          try {    
            dir("${WORKSPACE}/newrelic") {
              //TODO: Populate newrelic-token credential with token and check files into nexus
              withCredentials([string(credentialsId: 'newrelic-token', variable: 'TOKEN')]) {
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
  }
}
