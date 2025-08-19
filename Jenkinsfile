pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  tools { maven 'maven3' }

  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Diag') {
      steps {
        sh 'pwd && ls -la'
        sh 'find . -maxdepth 3 -name pom.xml -print'
      }
    }

    stage('Build & Test') {
      steps {
        sh 'mvn -B -U clean verify'
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
        }
      }
    }

    stage('Package') {
      steps {
        sh 'mvn -B -U -DskipTests package'
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }
  }
}
