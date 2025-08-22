pipeline {
    agent any
    
    environment {
        IMAGE_NAME = "your-image:latest"
        REPORT_DIR = "reports"
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${env.IMAGE_NAME} ."
            }
        }
        
        stage('Run Vulnerability Scan') {
            steps {
                script {
                    // Create reports directory
                    bat "mkdir ${env.REPORT_DIR} 2>nul || echo Directory exists"
                    
                    // Run Trivy scan
                    powershell '''
                        .\\trivy-scan.ps1 -ImageName $env:IMAGE_NAME -OutputFile "trivy-report.html"
                    '''
                }
            }
        }
        
        stage('Fail on Critical Vulnerabilities') {
            steps {
                script {
                    def report = readFile "${env.REPORT_DIR}/trivy-report.html"
                    if (report.contains("CRITICAL")) {
                        error("Critical vulnerabilities detected!")
                    }
                }
            }
        }
    }
    
    post {
        always {
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: env.REPORT_DIR,
                reportFiles: 'trivy-report.html',
                reportName: 'Trivy Vulnerability Report'
            ])
            
            // Cleanup
            bat "docker rmi ${env.IMAGE_NAME} || echo Image not found"
            bat "rmdir /s /q ${env.REPORT_DIR} || echo Cleanup failed"
        }
    }
}
