@Library('lib@master') _

pipeline {
    agent { label('master') }

    environment {
                VAULT_ADDR = 'https://vault.example.com:8200'
                VAULT_TOKEN = credentials('my-token')
                TARGET_GIT_URL = "${GITHUB_HOST}"
                TARGET_GIT_REPO = "${GITHUB_REPO}#refs/heads/${GIT_BRANCH}"
                GIT_TOKEN = credentials('my-token')
            }
    parameters {
        choice(name: 'MODE',
               choices:'build+deploy\nbuild',
               description: 'default build+deploy')
        choice(name: 'APP_ENVIRONMENT',
              choices:'dev\nuat\nprod\nint,
              description: 'Environment to operate, default dev')
        string(name: 'MY_FLASK_PORT', defaultValue: '9999', description: '')
    }
    post {
        always {
            deleteDir()
        }
        failure {
           sendMail()
       }
    }
    stages {
        stage('Make version') {
            steps {
                script {
                    env.Version = mkVersion(timestamp: 'true', base_version: '', tsSeparator: '')
                    env.Target = (env.GIT_BRANCH != 'master') ? "${env.GIT_BRANCH}" : 'master'
                    env.shaVersion = "${env.Target}-${env.Version}".toLowerCase()
                }
            }
        }
        stage('Build img'){
            agent {
               label('jenkins-slave')
            }
            environment {
                   APP_VERSION = "${shaVersion}"
            }
            steps {
               script {
                    sh '''
                      chmod +x ./build.sh && ./scripts/build.sh
                    '''
               }
           }
           when {
               expression {
                   params.MODE.contains('build')
               }
           }
       }
       stage('Exec operation') {
           agent {
               label('jenkins-slave')
           }
           steps {
               sh '''
                   echo "Checking..."
                   env
                   ls -alh
               '''

               script {
                   withCredentials([
                       string(credentialsId: 'kubeconfig', variable: 'KUBECONFIG'),
                   ]) {
                        sh('chmod +x ./deploy.sh && ./scripts/deploy.sh')
                   }
               }
           }
           when {
               expression {
                   params.MODE.contains('deploy')
               }
           }
       }

    }
}
