pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    parameters {
        choice(name: 'CHOICE', choices: ['Apply', 'Destroy'], description: 'Pick something')
    }

    stages {
        stage('init') {
            steps {
                sh """
                cd 01-vpc
                terraform init -reconfigure
                """
            }
        }
        stage('plan') {
            steps {
                when {
                    expression {
                        params.action == 'Apply'
                    }
                }
                sh """
                cd 01-vpc
                terraform plan
                """
            }
        }
        stage('deploy') {
            steps {
                sh """
                cd 01-vpc
                terraform apply -auto-approve
                """
            inputs {
                massage "should we continue?"
                ok "Yes, we should."
            }
            }
        }

        stage('destroy') {
            steps {
                when {
                    expression{
                        params.action == 'Destroy'
                    }
                }
                sh """
                cd 01-vpc
                terraform destroy -auto-approve
                """
            }
        }        
    }

    post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
        success { 
            echo 'I will run when pipeline is success'
        }
        failure { 
            echo 'I will run when pipeline is failure'
        }
    }
}