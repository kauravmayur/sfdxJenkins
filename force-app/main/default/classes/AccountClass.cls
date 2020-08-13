public class AccountClass {
	@InvocableMethod(label='Get Account')
    public static List<List<Account>> getAccount( ){
        List<List<Account>> accouns = new List<List<Account>>();
        List<Account> accList = [Select Id, Name from Account limit 2];
        System.debug('***getAccount***'+accList);
        accouns.add(accList);
        return accouns;
    }
}