#!groovy

import groovy.json.JsonSlurperClassic
import groovy.json.JsonSlurper

pipeline {
	def SFDX_USE_GENERIC_UNIX_KEYCHAIN = true
	def SF_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
    def SF_USERNAME=env.HUB_ORG_DH
    def SF_USERNAME_TARGET=env.HUB_TARGET_ORG_DH
    def SERVER_KEY_CREDENTALS_ID=env.JWT_CRED_ID_DH
    def TEST_LEVEL='RunLocalTests'
    def PACKAGE_NAME='sfdxPrject'
    def PACKAGE_VERSION = '04t0K0000010rN5QAI'
    def SF_INSTANCE_URL = env.SFDC_HOST_DH ?: "https://login.salesforce.com"
    def SFDC_USERNAME
    def toolbelt = tool 'toolbelt'
    agent any
    environment {
     
    }
    stages {    
	println SF_CONSUMER_KEY
    println SF_USERNAME
    println SERVER_KEY_CREDENTALS_ID
    println SF_INSTANCE_URL
	
	println 'Authorize DevHub'
        stage('Authorize DevHub') {
            steps {
                withCredentials([file(credentialsId: 'server.key', variable: 'server_key_file')]) {
                    sh returnStdout: true, script: "${toolbelt}/sfdx force:auth:jwt:grant --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --instanceurl ${SF_INSTANCE_URL}"
                }
            }
        }
    }
}
