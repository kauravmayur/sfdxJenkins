/**
|--------------------------------------------------------------------------
|@class         AccountTrigger
|--------------------------------------------------------------------------
|@description   To create Handler for Accounts Trigger
|--------------------------------------------------------------------------
|@created       12/11/2016
|@createdBy     Stu Watson
|@version       1.1.1
|--------------------------------------------------------------------------
|@modified      12/11/2016
|@modifiedBy    Stu Watson
|--------------------------------------------------------------------------
|@modified      27/11/2017
|@modifiedBy    Pankaj Jangra
|@description   Skip Trigger logic moved from TriggerHandler_Account to Main trigger ( Code optimization)
*/

trigger AccountTrigger on Account (after delete, after insert, after update, before delete, before insert, before update){
    
    if(TriggerFactory.executeTrigger('Account')){
        TriggerFactory.createAndExecuteHandler(TriggerHandler_Account.Class);   
    }
    
}