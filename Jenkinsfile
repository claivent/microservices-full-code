pipeline {
	agent any
  options { timestamps(); disableConcurrentBuilds(); skipDefaultCheckout(true) }
  tools { maven 'maven3' }

  environment {
		MODULE_POM = 'services/config-server/pom.xml'
    TEST_REPORTS = 'services/config-server/**/target/surefire-reports/*.xml'
    ARTIFACTS = 'services/config-server/target/*.jar'
  }

  stages {
		stage('Checkout') {
			steps {
				checkout scm
        sh 'pwd && ls -la && find . -maxdepth 3 -name pom.xml -print'
        sh "test -f ${MODULE_POM} || (echo '❌ ${MODULE_POM} not found' && exit 1)"
        sh 'git rev-parse --short HEAD'
      }
    }

    stage('Build & Test') {
			steps {
				sh "mvn -B -U -f ${MODULE_POM} clean verify"
      }
    }

    stage('Package') {
			steps {
				sh "mvn -B -U -f ${MODULE_POM} -DskipTests package"
      }
    }
  }

  post {
		always {
			junit testResults: "${TEST_REPORTS}", allowEmptyResults: true
      archiveArtifacts artifacts: "${ARTIFACTS}", fingerprint: true, onlyIfSuccessful: true
    }
  }
}
