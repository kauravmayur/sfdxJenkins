openssl version
openssl aes-256-cbc -salt -a -d -in assets/server.key.enc -out assets/server.key -pbkdf2 -k $SERVER_KEY_PASSWORD
# Setup SFDX environment variables
# https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_cli_env_variables.htm
export SALESFORCE_CLI_URL=https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
export SFDX_AUTOUPDATE_DISABLE=false
export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
export SFDX_DOMAIN_RETRY=600
export SFDX_LOG_LEVEL=DEBUG
# Install Salesforce CLI
mkdir sfdx
wget -qO- $SALESFORCE_CLI_URL | tar xJ -C sfdx --strip-components 1
'./sfdx/install'
export PATH=./sfdx/$(pwd):$PATH
# Output CLI version and plug-in information
sfdx update
sfdx --version
sfdx plugins:install salesforcedx@49.2.3
sfdx plugins --core
sfdx force:auth:jwt:grant --setdefaultdevhubusername --clientid $PRODUCTION_CONSUMER_KEY --jwtkeyfile assets/server.key --username $PRODUCTION_USERNAME
© 2020 GitHub, Inc.