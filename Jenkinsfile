pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  tools { maven 'maven3' }

  stages {
    stage('Checkout') {
		steps {
		checkout scm
        sh 'pwd && ls -la'
        sh 'test -f pom.xml || (echo "❌ pom.xml not found in $(pwd)" && exit 1)'

      }
    }

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
			// Když build spadne před testy, ať to nekřičí druhou chybou
      		junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
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
