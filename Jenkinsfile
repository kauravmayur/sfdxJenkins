pipeline {
    agent any
    environment {
        // Removed other variables for clarity...
       SFDX_USE_GENERIC_UNIX_KEYCHAIN = true
       SF_CONSUMER_KEY = "3MVG9n_HvETGhr3C0IBETj._LtyhM_yb8HXMP2QSpyRVInHpJgdBkUXOJsfSwEASLwZxr2pqzmKpI_LWJz1jC"
       SF_USERNAME = "krishna@rsystems.com.package"
       SF_INSTANCE_URL = "https://login.salesforce.com"
       SERVER_KEY_CREDENTALS_ID = "039c2d32-4253-4c49-8974-f652f3e0c125"
        
		steps {
                sh 'echo "Key is is $SF_CONSUMER_KEY"'
                sh 'echo "username is $SF_USERNAME"'
            }
        
        // ...
    }
    stages {    
        stage('Authorize DevHub') {
            steps {
                withCredentials([file(credentialsId: 'server.key', variable: 'server_key_file')]) {
                    sh returnStdout: true, script: "${toolbelt}/sfdx force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --instanceurl ${SF_INSTANCE_URL}"
                }
            }
        }
    }
}