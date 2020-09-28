# Authenticate with your QA sandbox environment
sfdx force:auth:jwt:grant --clientid $QA_CONSUMER_KEY --jwtkeyfile assets/server.key --username $QA_USERNAME -r https://test.salesforce.com
sfdx force:auth:jwt:grant --clientid $DEVPRO_CONSUMER_KEY --jwtkeyfile assets/server.key --username $DEVPRO_USERNAME -r https://test.salesforce.com
sfdx force:auth:jwt:grant --clientid $SANDYBOX_CONSUMER_KEY --jwtkeyfile assets/server.key --username $SANDYBOX_USERNAME -r https://test.salesforce.com
sfdx force:config:set defaultusername=$QA_USERNAME
# Get changed metadata files only since last merge and zip it
echo $LAST_SUCCESSFUL_COMMIT_DEVELOP
git diff --name-only $LAST_SUCCESSFUL_COMMIT_DEVELOP HEAD --diff-filter=AMR force-app | zip deploy.zip -@
# Unzip to a deployable directory and grab corresponding xml files (if applicable)
unzip deploy.zip -d deploy
export files=`git diff --name-only $LAST_SUCCESSFUL_COMMIT_DEVELOP HEAD --diff-filter=AMR force-app | grep -v '.xml\|.css\|.png'`
for file in $files; do cp $file-meta.xml \deploy/$file-meta.xml ;done
# Get all deleted and renamed metadata since last merge
export deletes=`git diff $LAST_SUCCESSFUL_COMMIT_DEVELOP HEAD --name-only --diff-filter=D force-app ; git diff HEAD $LAST_SUCCESSFUL_COMMIT_DEVELOP --name-only --diff-filter=R force-app`
mkdir delete
mkdir deletedevpro
mkdir deletesandybox
for delete in $deletes; do git --work-tree=delete checkout $LAST_SUCCESSFUL_COMMIT_DEVELOP $delete ; done
for delete in $deletes; do git --work-tree=deletedevpro checkout $LAST_SUCCESSFUL_COMMIT_DEVELOP $delete ; done
for delete in $deletes; do git --work-tree=deletesandybox checkout $LAST_SUCCESSFUL_COMMIT_DEVELOP $delete ; done
# Deploy everything
# sfdx force:source:deploy -p force-app
# UI Components that needs to be modified on bpfdev1 sandbox
rm -f deploy/force-app/main/default/layouts/Lead-Lead\ Layout.layout-meta.xml
rm -f deploy/force-app/main/default/layouts/Contact-Contact\ Layout.layout-meta.xml
rm -f deploy/force-app/main/default/classes/BPFLeadTriggerHandler.cls
rm -f deploy/force-app/main/default/classes/BPFLeadTriggerHandler.cls-meta.xml
rm -f deploy/force-app/main/default/classes/BPFLeadTriggerTest.cls
rm -f deploy/force-app/main/default/classes/BPFLeadTriggerTest.cls-meta.xml
rm -f deploy/force-app/main/default/triggers/BPFLeadTrigger.trigger
rm -f deploy/force-app/main/default/triggers/BPFLeadTrigger.trigger-meta.xml
rm -f deploy/force-app/main/default/flexipages/Opp_Page_Layout.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Account_Record_Page.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Account_Record_Page_Console.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Contact_Page_Layout.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Contact_Record_Page_Console.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Case_Record_Page.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Case_Record_Page1.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Lead_Record_Page.flexipage-meta.xml
rm -f deploy/force-app/main/default/flexipages/Lead_Record_Page_Console.flexipage-meta.xml
rm -f deploy/force-app/main/default/layouts/Case-New\ Case\ Layout.layout-meta.xml
rm -f deploy/force-app/main/default/layouts/Account-Account\ Layout.layout-meta.xml
rm -f deploy/force-app/main/default/layouts/Task-Task\ Layout.layout-meta.xml
rm -f deploy/force-app/main/default/layouts/Opportunity-Opportunity\ Layout.layout-meta.xml
# Deploy all changed metadata in the 'deploy/force-app' directory
testClasses=""
for f in force-app/main/default/classes/*Test.cls; do testClasses+="$(basename $f .cls),"; done;
testClasses=${testClasses%?}
echo $testClasses
#sfdx force:source:deploy -p deploy/force-app -l RunSpecifiedTests -r "$testClasses"
sfdx force:source:deploy -p deploy/force-app
# Delete the retrieved metadata
sfdx force:source:delete -p delete -r
# Same steps for DevPro & Sandybox
sfdx force:config:set defaultusername=$DEVPRO_USERNAME
sfdx force:source:deploy -p deploy/force-app
sfdx force:source:delete -p deletedevpro -r
sfdx force:config:set defaultusername=$SANDYBOX_USERNAME
sfdx force:source:deploy -p deploy/force-app
sfdx force:source:delete -p deletesandybox -r