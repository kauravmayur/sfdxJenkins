pipeline {
    agent any
    stages {
        stage('Example Username/Password') {
            environment {
               SFDX_USE_GENERIC_UNIX_KEYCHAIN = true
			   SF_CONSUMER_KEY = "3MVG9n_HvETGhr3C0IBETj._LtyhM_yb8HXMP2QSpyRVInHpJgdBkUXOJsfSwEASLwZxr2pqzmKpI_LWJz1jC"
			   SF_USERNAME = "krishna@rsystems.com.package"
			   SF_INSTANCE_URL = "https://login.salesforce.com"
			   SERVER_KEY_CREDENTALS_ID = "039c2d32-4253-4c49-8974-f652f3e0c125"
            }
            steps {
                echo "SF_CONSUMER_KEY =  ${env.SF_CONSUMER_KEY}"
				echo "SF_USERNAME =  ${env.SF_USERNAME}"
				echo "SF_INSTANCE_URL =  ${env.SF_INSTANCE_URL}"
				echo "SERVER_KEY_CREDENTALS_ID =  ${env.SERVER_KEY_CREDENTALS_ID}"
				
				echo "***************************************************************"
				
            }
        }
        
    }
}
