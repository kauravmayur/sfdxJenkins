# Scripts to remove conflicting metadata and profiles
# rm -f force-app/main/default/settings/Case.settings-meta.xml
rm -f force-app/main/default/objects/Case/fields/IsSelfServiceClosed.field-meta.xml
rm -f force-app/main/default/objects/Case/fields/IsVisibleInSelfService.field-meta.xml
rm -f force-app/main/default/objects/Case/fields/SourceId.field-meta.xml
rm -f force-app/main/default/objects/Contact/fields/CanAllowPortalSelfReg.field-meta.xml
rm -f force-app/main/default/profiles/Trial\ Customer\ Portal\ User.profile-meta.xml
rm -f force-app/main/default/quickActions/SendEmail.quickAction-meta.xml
rm -f force-app/main/default/quickActions/Case.SendEmail.quickAction-meta.xml
# Scripts to remove differences in user permissions (fix for profile deployment)
sed -i 's/AllowUniversalSearch/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/AllowViewKnowledge/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/EnableCommunityAppLauncher/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/EditKnowledge/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/FieldServiceAccess/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/EditPublicReports/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/SendExternalEmailAvailable/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ManageDashboards/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ManageKnowledge/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ManageKnowledgeImportExport/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ManageSearchPromotionRules/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ShareInternalArticles/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ViewDataLeakageEvents/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/EditReports/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/ManageEntitlements/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/AssignTopicsImportExport/AssignTopics/' force-app/main/default/profiles/*.xml
sed -i 's/Case.IsSelfServiceClosed/Case.IsClosedOnCreate/' force-app/main/default/**/*.xml
sed -i 's/Case.IsVisibleInCss/Case.IsClosedOnCreate/' force-app/main/default/**/*.xml
sed -i 's/Case.IsVisibleInSelfService/Case.IsClosedOnCreate/' force-app/main/default/**/*.xml
sed -i 's/Event.IsVisibleInSelfService/Case.IsClosedOnCreate/' force-app/main/default/**/*.xml
sed -i 's/Task.IsVisibleInSelfService/Case.IsClosedOnCreate/' force-app/main/default/**/*.xml
sed -i 's/Contact.CanAllowPortalSelfReg/Case.IsClosedOnCreate/' force-app/main/default/**/*.xml
# Scripts to fix Case.settings xml file
sed -i 's/<emailServicesAddress>.*<\/\emailServicesAddress>//' force-app/main/default/settings/Case.settings-meta.xml
sed -i 's/<isVerified>.*<\/\isVerified>//' force-app/main/default/settings/Case.settings-meta.xml