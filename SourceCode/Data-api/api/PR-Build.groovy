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



podTemplate(
    label: worker_label,
    containers: [
            containerTemplate(name: 'gradle', image: 'essoegis/gradle:5.4-sdk8-alpine',  resourceRequestMemory: '1024Mi', resourceLimitMemory: '2048Mi', command: 'cat', ttyEnabled: true, privileged: true),
            containerTemplate(name: 'docker', image: 'docker:18.06-dind', command: 'cat', ttyEnabled: true),
            containerTemplate(name: 'jq', image: 'endeveit/docker-jq', command: 'cat', ttyEnabled: true)
    ],
    volumes: [
            //hostPathVolume(mountPath: '/home/jenkins', hostPath: '/tmp/jenkins/'),
            hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/tmp/jenkins/.gradle'),
            hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    ])
{
    node(worker_label) {

      stage('Prepare') {
          scmInfo = checkout scm
          echo "scm : ${scmInfo}"
          gitCommit = scmInfo.GIT_COMMIT
          shortGitCommit = gitCommit[0..10]
          previousGitCommit = scmInfo.GIT_PREVIOUS_COMMIT
          buildUrl = env.BUILD_URL
          containerTag = "ci-${shortGitCommit}"
          gitUrl = scmInfo.GIT_URL

          container('gradle') {
              sh """
                  echo "BUILD_URL=${buildUrl}"
                  echo "GIT_COMMIT=${gitCommit}"
                  echo "SHORT_GIT_COMMIT=${shortGitCommit}"
                  java -version
                  gradle -v
              """
          }

      }

      stage('Compile'){
        container('gradle'){
          try { 
            sh """
            java -version
            gradle -v
            gradle clean assemble -PprojVersion=${shortGitCommit}
            """
            output('Build', 'success')
          }
          catch(err) {
            output('Build', 'failure')
            throw err
          } 
        }
      }

      stage('Unit Tests') {
        container('gradle'){
          steps {
            script {
              try {
                sh "gradle test -PprojVersion=${shortGitCommit}"
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
}
