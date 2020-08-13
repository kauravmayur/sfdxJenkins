public class ActionMethods_Controller {

    

    public List<Account> acclist{get; set;}
    public Account acc{get; set;}
    public ActionMethods_Controller(){
        acc = new Account();
        getAllAccount();
    }
    
    public void createAccount() {
        System.debug('*** createAccount : '+acc);
        //acc = new Account();
        insert acc;
        getAllAccount();
    }
    
    public List<Account> getAllAccount(){
        acclist = [SELECT 
                    AccountNumber,Name,AnnualRevenue,Id,Number_of_Contacts__c,Type,Website 
                    FROM Account 
                    WHERE LastModifiedDate = Today];
        return acclist;
    }
}