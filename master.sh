## Change placeholder emails to actual sales & marketing team email
sed -i 's/salesteamplaceholder/salesteam/' force-app/main/default/workflows/*.xml
sed -i 's/marketingplaceholder/marketing/' force-app/main/default/workflows/*.xml
sed -i 's/staging-//' force-app/main/default/flows/*.xml
## Change NPS Email Alerts to use Org Wide Addresses
sed -i '/Contact_NPS_Survey/,/\/alerts/ s/<senderType>DefaultWorkflowUser<\/senderType>/<senderAddress>hello@betterplaceforests.com<\/senderAddress><senderType>OrgWideEmailAddress<\/senderType>/' force-app/main/default/workflows/Contact.workflow-meta.xml
sed -i '/Opportunity_NPS_Survey/,/\/alerts/ s/<senderType>DefaultWorkflowUser<\/senderType>/<senderAddress>hello@betterplaceforests.com<\/senderAddress><senderType>OrgWideEmailAddress<\/senderType>/' force-app/main/default/workflows/Opportunity.workflow-meta.xml
# Authenticate with Production org
sfdx force:auth:jwt:grant --clientid $PRODUCTION_CONSUMER_KEY --jwtkeyfile assets/server.key --username $PRODUCTION_USERNAME
sfdx force:config:set defaultusername=$PRODUCTION_USERNAME
# Get changed metadata files only since last merge and zip it
echo $LAST_SUCCESSFUL_COMMIT_MASTER
git rev-parse $LAST_SUCCESSFUL_COMMIT_MASTER
git diff --name-only $LAST_SUCCESSFUL_COMMIT_MASTER HEAD --diff-filter=AMR force-app | zip deploy.zip -@
# Unzip to a deployable directory and grab corresponding xml files (if applicable)
unzip deploy.zip -d deploy
export files=`git diff --name-only $LAST_SUCCESSFUL_COMMIT_MASTER HEAD --diff-filter=AMR force-app | grep -v '.xml\|.css\|.png'`
for file in $files; do cp $file-meta.xml \deploy/$file-meta.xml ;done
## Get all deleted and renamed metadata since last merge
export deletes=`git diff $LAST_SUCCESSFUL_COMMIT_MASTER HEAD --name-only --diff-filter=D force-app ; git diff HEAD $LAST_SUCCESSFUL_COMMIT_MASTER --name-only --diff-filter=R force-app`
mkdir delete
for delete in $deletes; do git --work-tree=delete checkout $LAST_SUCCESSFUL_COMMIT_MASTER $delete ; done
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
# Deploy everything
# sfdx force:source:deploy -p force-app -l RunLocalTests
# Deploy all changed metadata in the 'deploy/force-app' directory
# sfdx force:source:deploy -p deploy/force-app -l RunSpecifiedTests -r AutoConvertLeadsTest,PostToRelatedRecordChatterTest
# sfdx force:source:deploy -p deploy/force-app -l RunLocalTests
if [ -d "deploy/force-app/main/default/classes" ] ||  [ -d "deploy/force-app/main/default/triggers" ]; then sfdx force:source:deploy -p deploy/force-app -l RunLocalTests; else sfdx force:source:deploy -p deploy/force-app -l RunSpecifiedTests -r "skip"; fi