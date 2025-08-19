pipeline {
	agent any
  options { timestamps(); disableConcurrentBuilds() }
  tools { maven 'maven3' }

  stages {
		stage('Checkout') { steps { checkout scm } }

    stage('Build & Test') {
			steps {
				sh 'mvn -B -U -pl services/config-server -am clean verify'
      }
      post {
				always {
					junit 'services/config-server/**/target/surefire-reports/*.xml'
        }
      }
    }

    stage('Package') {
			steps {
				sh 'mvn -B -U -pl services/config-server -am -DskipTests package'
        archiveArtifacts artifacts: 'services/config-server/target/*.jar', fingerprint: true
      }
    }
  }
}
