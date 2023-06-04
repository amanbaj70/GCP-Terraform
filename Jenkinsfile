pipeline {
    
    agent any
    
    tools {
        jdk 'jdk11'
        maven 'maven3'
    }   
    
    environment{
        SCANNER_HOME=tool 'sonar-scanner'
    }
    
    stages {
        stage('Git checkout') {
            steps {
                
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/amanbaj70/Shopping-Cart.git'
                
            }
        }
        
        stage('Maven compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        
        stage('Sonarqube code analysis') {
            steps {
                sh ''' 
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.url=http://34.131.252.20:9000/ \
                    -Dsonar.login=squ_bfe93937e815f3a6c1c80512105e61419f670a4e \
                    -Dsonar.projectName=shopping-cart \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=shopping-cart
                '''
            }
        }
        
        stage('Maven build') {
            steps {
                sh 'mvn clean package -DskipTests=true'
            }
        }
        
        stage('OWASP dependecy check') {
            steps {
                dependencyCheck additionalArguments: '--scan target/', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Docker images build') {
            steps {
                script{
                    withDockerRegistry(credentialsId: '4d83d3d2-5db7-4b1b-ba55-2ed272dbfe93', toolName: 'docker') {
                    
                        sh '''
                        docker build -t shopping-cart -f docker/Dockerfile .
                        docker tag shopping-cart amanbajpai/shopping-cart:latest
                        docker push amanbajpai/shopping-cart:latest
                        
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to docker') {
            steps {
                script{
                    withDockerRegistry(credentialsId: '4d83d3d2-5db7-4b1b-ba55-2ed272dbfe93', toolName: 'docker') {
                    
                        sh '''
                        
                        docker run -d --name shopping-cart -p 8070:8070 shopping-cart
                        docker ps
                        
                        '''
                    }
                }
            }
        }
        
    }
}
