pipeline {
	agent {
		label "slave1"
    }
    options {
		timestamps()
        parallelsAlwaysFailFast()
    }

    stages {
		stage('checkout') {
			steps {
				git branch: 'master',
    			    credentialsId: '6300dc75-8c6c-4d43-b6ae-013ec917776e',
                    url: 'https://github.com/Ninjasimov/Projet-CD-CI.git'
			}
		}
		stage('testing') {
			   parallel {
            	stage('junit') {
            		tools {
		                maven "maven3"
	                } 

                    steps {
                        sh "mvn   -s settings.xml  test -Dmaven.test.failure.ignore=true"
                        step([$class: 'XUnitBuilder',
    thresholds: [
        [$class: 'SkippedThreshold', failureThreshold: '0'],
        // Allow for a significant number of failures
        // Keeping this threshold so that overwhelming failures are guaranteed
        //     to still fail the build
        [$class: 'FailedThreshold', failureThreshold: '1', thresholdmode: 'percent']],
    tools: [[$class: 'JUnitType', pattern: 'target/surefire-reports/**.xml']]]) 
                    }
                }
                stage('pmd') {
                    steps {
                        sh "mvn  -s settings.xml  pmd:pmd"
                    }
                }
              
            }
		}
		stage('deploy'){
		       environment {
        MONGODB_ADMIN_USER = 'myUserAdmin'
        MONGODB_ADMIN_PWD = 'abc123'
        MONGODB_URL = '192.168.1.147'
        MONGODB_PORT = '27017'
    }
		    steps{
		        sh "mvn -DMONGODB_ADMIN_USER=$MONGODB_ADMIN_USER -DMONGODB_ADMIN_PWD=$MONGODB_ADMIN_PWD -DMONGODB_URL=$MONGODB_URL -DMONGODB_PORT=$MONGODB_PORT -s settings.xml clean package dockerfile:build -Dmaven.test.failure.ignore=true"
		    }
		}
		stage('dockerhub') {
		    	tools {
		                maven "maven3"
	                } 
		    	                     environment {
    //Use Pipeline Utility Steps plugin to read information from pom.xml into env variables
    IMAGE = readMavenPom().getArtifactId()
    VERSION = readMavenPom().getVersion()
    }
		    steps {
		      
		       sh "echo ${VERSION}"
		    sh "docker login -u emiup -p devops_@0"
		    sh 'docker tag wunderit/projetcd:${VERSION} emiup/wunderit-projetcd:${VERSION}'
		    sh 'docker push emiup/wunderit-projetcd:${VERSION}'
		    }
		}
    }
}