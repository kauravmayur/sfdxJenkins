@isTest
public class AccountProcessorTest {
    @isTest static void testCountContacts(){
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        List<Id> accountIds = new List<Id>();
        for(integer i=0; i<=5; i++){
            Account acc = new Account();
            acc.name = 'Test Account'+i;
            accList.add(acc);
        }
        insert accList;
        for(Account acc: accList){
            accountIds.add(acc.Id);
            for(integer i=0; i<=5; i++){
                Contact con = new Contact();
                con.Lastname = 'Test Contact'+ i +acc.Name;
                con.AccountId = acc.Id;
                conList.add(con);
            }
        }
        insert conList;
        Test.setMock(HttpCalloutMock.class, new AccountProcessorCalloutMock());
        Test.startTest();
        	
        	AccountProcessor.countContacts(accountIds);
        Test.stopTest();
        Account accDetails = [SELECT Id, Name, Number_of_Contacts__c, 
                                 (SELECT Id, Name FROM Contacts)
                                 FROM Account LIMIT 1];
        System.assertEquals(6, accDetails.Number_of_Contacts__c);
    }	
}