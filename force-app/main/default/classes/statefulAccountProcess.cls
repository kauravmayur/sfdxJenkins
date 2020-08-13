//public class statefulAccountProcess implements Database.Batchable<sObject>, Database.stateful{
public class statefulAccountProcess implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public List<Id> successfulAccIds = new List<Id>();
    public Map<Id, String> failedAccMap = new Map<Id, String>();
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT ID, Name,BillingStreet, BillingCity, BillingState, Match_Billing_Address__c, BillingPostalCode, ShippingPostalCode FROM ACCOUNT');
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        List<account> accounts = new List<account>();
        for(account acc: scope){
            if(String.isBlank(acc.BillingStreet)){
                acc.BillingStreet = '620 SW 5th Avenue Suite 400 Portland, Oregon 97204 United States';
            }
            if(String.isBlank(acc.BillingCity)){
                acc.BillingCity = 'Portland';
            }
            if(String.isBlank(acc.BillingState)){
                acc.BillingState = 'OR';
            }
            acc.Match_Billing_Address__c = true;
            accounts.add(acc);
        }
        
        if(accounts.size() > 0){
            Database.SaveResult[] updateAccounts = Database.update(accounts, false);
            for(Database.SaveResult sr: updateAccounts){
                if(sr.isSuccess()){
                    // Operation was successful, so get the ID of the record that was processed
                    successfulAccIds.add(sr.getId());
                }
                else{
                    for(Database.Error er: sr.getErrors()){
                        // Operation failed, so get all errors           
                        failedAccMap.put(sr.getId(), er.getStatusCode()+er.getMessage()+er.getFields());   
                    }
                }
            }
		}
                
    }
    public void finish(Database.BatchableContext bc){
        System.debug('***successfulAccIds : '+successfulAccIds.size());
        System.debug('***failedAccMap : '+failedAccMap.size());
        System.debug('***failedAccMap : '+failedAccMap);
        AccountProcessor.countContacts(successfulAccIds);
        //statefulAccountProcess sfa = new statefulAccountProcess();
		//id batchId = Database.executeBatch(sfa, 200);
    }
}