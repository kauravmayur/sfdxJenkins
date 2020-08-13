public class AccountProcessor {
	@future(callout=true)
    public static void countContacts(List<Id> AccountId){
        List<Account> accList = [SELECT Id, Name, Number_of_Contacts__c, 
                                 (SELECT Id, Name FROM Contacts)
                                 FROM Account WHERE ID IN: AccountId];
        for(Account acc: accList){
            if(acc.Contacts.Size() > 0){
            	acc.Number_of_Contacts__c = acc.Contacts.Size();
            }
        }
        update accList;
    }
}