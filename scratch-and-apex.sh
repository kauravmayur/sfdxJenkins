# Code Testing
# Create scratch org
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:org:create --setdefaultusername --definitionfile config/project-scratch-def.json --wait 10 --durationdays 1; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:package:install -p 04t3o000000xFLqAAM -w 10; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:source:deploy -m Settings:Security; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:source:deploy -p force-app; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:user:permset:assign --permsetname "Audit_Field_Permissions"; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then mkdir junit; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:apex:test:run --wait 10 -d junit -r junit --codecoverage --testlevel RunLocalTests; fi
if [ "$CI_BRANCH" != "develop" ] && [ "$CI_BRANCH" != "master" ]; then sfdx force:org:delete --noprompt; fi