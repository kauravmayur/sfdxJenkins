/**
|--------------------------------------------------------------------------
|@class TriggerHandler_Account
|--------------------------------------------------------------------------
|@description   Trigger Handler class for Account
|--------------------------------------------------------------------------
|
|@created       05/09/2016
|@createdBy     Pankaj Jangra
|@version       1.1.1
|
|@modified      21/18/2016
|@modifiedBy    Stu Watson
|@jira          NA  
*/

public class TriggerHandler_Account implements ITrigger {
    
    public Set<Id> set_WrittenOffAccounts;
    
    public TriggerHandler_Account(){
        set_WrittenOffAccounts = new Set<Id>();
    }
    
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore() {
        
        //JIRA 2543
        //Model_EventLog.SetupEtlAccountLogging(trigger.new);
    }
    
    /**
    |--------------------------------------------------------------------------
    |@method bulkAfter
    |--------------------------------------------------------------------------
    |
    |@description SkipTrigger logic moved to main AccountTrigger
    |
    |@created     05/09/2016
    |@createdBy   Pankaj Jangra
    |@modified    11/27/2017
    |@modifiedBy  Pankaj Jangra
    |@exception   NA
    |@calling     updatePODAssignment(), cancelSelfServeReminderTaskOnRegistration()
    |@return      Void
    */
    public void bulkAfter() {
        //Krishna - JIRA CES20-3815
        if(trigger.isInsert){
            //Model_Entitlement.setBillingAccountEntitlement((List<Account>) trigger.new);
        }
        
        if(trigger.isInsert || trigger.isUpdate) {
            //if(!System.isBatch() && UserInfo.getUserId() != System.Label.IntegrationUser) {
                //Model_Account.updatePODAssignment((Map<Id, Account>)trigger.newMap, (Map<Id, Account>)trigger.oldMap); 
            //} 
        }
        if (trigger.isUpdate) {
            //Model_Account.cancelSelfServeReminderTaskOnRegistration((List<Account>) trigger.new);
        }
    }
        
    public void beforeInsert(SObject so) {
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        
    }
    
    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so) {
    }
    
    public void afterInsert(SObject so) {        
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        /*
        Account OldAccount = (Account) oldSo;
        Account NewAccount = (Account) so;
        if('Mobility'.equalsIgnoreCase(NewAccount.Type) && 'TELUS'.equalsIgnoreCase(NewAccount.Brand__c) && NewAccount.Written_Off__c == true && OldAccount.Written_Off__c != true){
            set_WrittenOffAccounts.add(NewAccount.Id); 
        }
        */
    }
    
    public void afterDelete(SObject so) {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally() {
        if(!set_WrittenOffAccounts.isEmpty()){
            closeAllCasesAndTask(set_WrittenOffAccounts);
        }
    }
    /**
    |--------------------------------------------------------------------------
    |@method closeAllCasesAndTask
    |--------------------------------------------------------------------------
    |
    |@description Closing all the cases and Task Related to Written Off Account
    |
    |@Jira        https://jira.tsl.telus.com/browse/CES20-4069
    |@created     09/10/2018
    |@createdBy   Pankaj Jangra
    |@modified    09/10/2018
    |@modifiedBy  Pankaj Jangra
    |@exception   NA
    |@calling     Model_case.getOpenCasesAccountId(), Model_Task.getOpenTasksByCaseId();
    |@return      Void
    */
    public void closeAllCasesAndTask(Set<Id> set_AccountIds){
        /*
        List<Case> lst_Cases = Model_case.getOpenCasesAccountId(set_WrittenOffAccounts);
        Set<Id> set_CaseIds = new Set<Id>();
        for(Case var : lst_Cases){
            var.Status = 'Pending Close';
            var.Result__c = 'Auto Close';
            var.Reason__c = 'Account Written Off';
            var.Pending_Close_Duration__c = 0;
            var.Suppress_Close_Email__c = true;
            if('Queue'.equalsIgnoreCase(var.Owner.Type)){
                var.OwnerId = UserInfo.getUserId();
            }
            if('Email'.EqualsIgnoreCase(var.Notification__c) && (var.Notification_Id__c == null || var.Notification_Id__c == '')){
                var.Notification__c = 'None';
            }
            set_CaseIds.add(var.Id);            
        }
        if(!set_CaseIds.isEmpty()){
            List<Task> lst_OpenTask = Model_Task.getOpenTasksByCaseId(set_CaseIds);
            for(Task var : lst_OpenTask){
                var.Status = 'Cancelled';
                var.Reason_Code__c = 'Other';
            }
            Database.SaveResult[] SR_Task = Database.update(lst_OpenTask, false);
            Database.SaveResult[] SR_Case = Database.update(lst_Cases, false);
        }    
        */
    }
}